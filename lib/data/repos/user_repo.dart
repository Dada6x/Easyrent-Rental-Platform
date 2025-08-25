import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:easyrent/core/services/api/end_points.dart';
import 'package:easyrent/data/models/plan_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easyrent/core/constants/utils/rawSnackBar.dart';
import 'package:easyrent/core/services/api/api_consumer.dart';
import 'package:easyrent/core/services/api/errors/error_model.dart';
import 'package:easyrent/core/services/api/errors/exceptions.dart';
import 'package:easyrent/data/Session/app_session.dart';
import 'package:easyrent/data/models/user_model.dart';
import 'package:easyrent/main.dart';
import 'package:easyrent/presentation/navigation/navigator.dart';
import 'package:easyrent/presentation/views/auth/views/verification_code_page.dart';
// import 'package:dio/dio.dart' hide MultipartFile;
import 'package:dio/dio.dart' as dio;

class Userrepo {
  Userrepo(this.api);
  final ApiConsumer api;

//   //!-----------------------login---------------------------------->
  Future<Either<String, User>> loginUser({
    required String number,
    required String password,
  }) async {
    try {
      final response = await api.post(
        EndPoints.login,
        data: {
          ApiKey.phone: number,
          ApiKey.password: password,
        },
      );

      if (response.statusCode == 200) {
        debug.f("User Logged In ${response.statusCode}");
        final token = response.data['accessToken'];
        await saveToken(token);
        await userPref?.setBool('isLoggedIn', true);
        //! fetching Profile data
        final profileResult = await getProfile();
        return profileResult.fold(
          (e) {
            debug.e("Failed to fetch profile after login");
            return const Left("Failed to load profile");
          },
          (_) {
            Get.off(() => const HomeScreenNavigator());
            return Right(AppSession().user!);
          },
        );
      }
      showErrorSnackbar("Something went wrong. Please try again later.");
      return const Left('Unexpected error during login');
    } on ServerException catch (e) {
      debug.e("Server Exception: ${e.errorModel.message}");
      return Left(e.errorModel.message);
    }
  }

//!-----------------------Register ---------------------------------->
  Future<Either<String, String>> signUpUser({
    required String number,
    required String userName,
    required String password,
    required Map<String, double> latLang,
  }) async {
    try {
      final response = await api.post(
        EndPoints.registerUser,
        data: {
          ApiKey.phone: number,
          ApiKey.password: password,
          ApiKey.userName: userName,
          ApiKey.pointsDto: latLang,
          // ApiKey.fcm_token:fcm_token,
          //TODO for notifications and FCM tokens we kinda need HMS for huwaei devices
        },
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        //! take the Id
        final id = response.data['userId'];
        Get.off(() => VerificationCodePage(userId: id));
        return const Right("User Registered waiting to verify");
      }
      showErrorSnackbar("Something went wrong. Please try again later.");
      return const Left('Unexpected error');
    } on ServerException catch (e) {
      debug.e("Exception $e");
      return Left(e.errorModel.message);
    }
  }

//!-----------------------Verify Code---------------------------------->
  Future<Either<String, User>> verifyCode(
      {required int code, required int userId}) async {
    try {
      final response = await api.post(
        EndPoints.verifyCode(userId),
        data: {
          ApiKey.code: code.toString(),
        },
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        debug.t("code is true and verified ");
        final token = response.data['accessToken'];
        await saveToken(token);
        userPref?.setBool('isLoggedIn', true);
        final profileResult = await getProfile();
        return profileResult.fold(
          (e) {
            debug.e("Failed to fetch profile after verify pin code ");
            return const Left("Failed to load profile");
          },
          (_) {
            return Right(AppSession().user!);
          },
        );
      }
      showErrorSnackbar("Something went wrong. Please try again later.");
      return const Left('Unexpected error');
    } on ServerException catch (e) {
      debug.e("Exception $e");
      return Left(e.errorModel.message);
    }
  }

//!-----------------------Get Profile Info ---------------------------------->
  Future<Either<ServerException, User>> getProfile() async {
    try {
      final response = await api.get(
        EndPoints.me,
      );
      debug.i("Profile Request ${response.statusCode}");
      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        AppSession().user = user;
        return Right(user);
      } else {
        return Left(ServerException(
            errorModel:
                ErrorModel(response.statusCode, response.errorMessage)));
      }
    } on ServerException catch (e) {
      debug.e("ServerException: $e");
      showErrorSnackbar(" exception ${e.errorModel.message}");
      return Left(e);
    } catch (e) {
      debug.e("Unexpected exception: $e");
      return Left(ServerException(errorModel: ErrorModel(4, e.toString())));
    }
  }
  //! fromJson
//   Future<Either<ServerException, User>> getProfile() async {
//   try {
//     final json = await _loadJson('user.json');
//     final user = User.fromJson(json);
//     AppSession().user = user;
//     return Right(user);
//   } catch (e) {
//     debug.e("Error loading profile: $e");
//     return Left(ServerException(
//       errorModel: ErrorModel(500, "Failed to load profile from mock"),
//     ));
//   }
// }

//!-----------------------Log OUt ---------------------------------->

  void logout(BuildContext context) {
    userPref?.setBool('isLoggedIn', false);
    deleteToken();
    showSnackbarWithContext("We're Going to miss You ", context);
    AppSession().user = null;
    Get.offAll("/login");
  }

//!----------------------Upload User Image------------------------->
  Future<Either<String, String>> uploadUserImage(XFile image) async {
    try {
      final fileName = image.path.split('/').last;

      final formData = dio.FormData.fromMap({
        'user-image': await dio.MultipartFile.fromFile(
          image.path,
          filename: fileName,
        ),
      });

      final response = await api.post(
        EndPoints.uploadProfileImage,
        data: formData,
        isFormData: true,
      );

      if (response.statusCode == 200) {
        showSuccessSnackbar("Look Crispy My 🥷");
        debug.i("Image Uploaded, statusCode: ${response.statusCode}");
        return const Right("Image uploaded successfully");
      } else {
        return const Left("Unexpected Error");
      }
    } catch (e) {
      debug.e("Upload Exception: $e");
      return const Left("Upload failed");
    }
  }

  // delete ImageProfile
  Future<Either<String, void>> deleteImageProfile() async {
    try {
      final response = await api.post(
        EndPoints.deleteProfileImage,
      );
      if (response.statusCode == 200) {
        debug.t("Profile Image Deleted");
        showErrorSnackbar("Something went wrong. Please try again later.");
      }
      showErrorSnackbar("Something went wrong. Please try again later.");
      return right(null);
    } on ServerException catch (e) {
      debug.e("Exception $e");
      return Left(e.errorModel.message);
    }
  }

//   //!-----------------------ResendCode---------------------------------->
  Future<Either<String, void>> resendCode({required int userId}) async {
    try {
      final response = await api.get(
        EndPoints.resendCode(userId),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        debug.t("code Resent");
        return right(null);
      }
      showErrorSnackbar("Something went wrong. Please try again later.");
      return const Left('Unexpected error');
    } on ServerException catch (e) {
      debug.e("Exception ${e.errorModel.message}");
      return Left(e.errorModel.message);
    }
  }

//   //!-----------------------update UserName---------------------------------->
  Future<Either<String, String>> updateUsername({
    required String currentPassword,
    required String newUsername,
    required BuildContext context,
  }) async {
    try {
      final response = await api.patch(
        EndPoints.update,
        data: {
          'myPassword': currentPassword,
          'username': newUsername,
        },
      );

      if (response.statusCode == 200) {
        showSnackbarWithContext("UserName updated successfully", context);
        return const Right("Username updated successfully");
      }
      return const Left("Unexpected error");
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  //   //!-----------------------Update PassWord---------------------------------->
  Future<Either<String, String>> updatePassword({
    required String currentPassword,
    required String newPassword,
    required BuildContext context,
  }) async {
    try {
      final response = await api.patch(
        EndPoints.update,
        data: {
          'myPassword': currentPassword,
          'password': newPassword,
        },
      );

      if (response.statusCode == 200) {
        showSnackbarWithContext("Password updated successfully", context);
        return const Right("Password updated successfully");
      }
      return const Left("Unexpected error");
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }
  //   //!-----------------------Delete Account---------------------------------->

  Future<Either<String, void>> deleteAccount({required String password}) async {
    try {
      final response = await api.delete(
        EndPoints.update,
        data: {'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(null);
      }
      return const Left("Unexpected error");
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

//!----------------------- Subscription Plans ---------------------------------->

  Future<List<SubscriptionPlan>> getSubscriptionPlan() async {
    final response = await api.get(EndPoints.getSubscriptions);
    return List<SubscriptionPlan>.from(
        response.data.map((plan) => SubscriptionPlan.fromJson(plan)));
  }

  Future<dynamic> goToStripePage(int planId) async {
    PaymentRequest model = PaymentRequest(planId: planId.toString());
    final response = await api.post(EndPoints.goToStripe, data: model.toJson());
    debug.d(response.data['url']);
    return response.data['url'];
  }

  // Future<dynamic> orderSubsctiption() async{
  //   final resposne=await api.
  // }
}

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
//$$$$$$$$$$$$$$$$$$//TODOD REMOVE THIS NONSCENSE :D $$$$$$$$$$$$$$$$$$$$$$$$$
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// class Userrepo {
//   Userrepo(this.api);
//   final ApiConsumer api;

// Future<Either<String, User>> loginUser({
//   required String number,
//   required String password,
// }) async {
//   try {
//     final response = await _loadJson('login.json');
//     final token = response['accessToken'];
//     await saveToken(token);
//     await userPref?.setBool('isLoggedIn', true);
//     final profileResult = await getProfile();
//     return profileResult.fold(
//       (e) => const Left("Failed to load profile"),
//       (_) {
//         Get.off(() => const HomeScreenNavigator());
//         return Right(AppSession().user!);
//       },
//     );
//   } catch (e) {
//     debug.e("Error: $e");
//     showErrorSnackbar("Something went wrong.");
//     return const Left("Login failed");
//   }
// }
// Future<Either<String, String>> signUpUser({
//   required String number,
//   required String userName,
//   required String password,
//   required Map<String, double> latLang,
// }) async {
//   try {
//     await _loadJson('login.json');
//     return const Right("Signed up");
//   } catch (e) {
//     debug.e("Error: $e");
//     showErrorSnackbar("Signup failed");
//     return const Left("Signup failed");
//   }
// }
// Future<Either<String, User>> verifyCode({required int code}) async {
//   try {
//     final response = await _loadJson('login.json');
//     final token = response['accessToken'];
//     await saveToken(token);
//     userPref?.setBool('isLoggedIn', true);
//     final profileResult = await getProfile();
//     return profileResult.fold(
//       (e) => const Left("Failed to load profile"),
//       (_) => Right(AppSession().user!),
//     );
//   } catch (e) {
//     debug.e("Error: $e");
//     showErrorSnackbar("Verification failed");
//     return const Left("Verification failed");
//   }
// }

// Future<Either<String, String>> logoutUser() async {
//   try {
//     await _loadJson('login.json');
//     userPref?.setBool('isLoggedIn', false);
//     deleteToken();
//     return const Right("Logged out");
//   } catch (e) {
//     debug.e("Error: $e");
//     showErrorSnackbar("Logout failed");
//     return const Left("Logout failed");
//   }
// }
// }

//@ helper funs ... so funny hehehe :D (help).
Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
  debug.i("Token Saved $token");
}

Future<void> deleteToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  debug.i("Token Deleted ");
}

Future<void> setSubscribeSuccess() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isSuccess', true);
}

Future<Map<String, dynamic>> _loadJson(String fileName) async {
  final data = await rootBundle.loadString('assets/json/$fileName');
  return json.decode(data);
}
