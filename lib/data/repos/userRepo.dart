import 'package:dartz/dartz.dart';
import 'package:easyrent/core/constants/utils/rawSnackBar.dart';
import 'package:easyrent/core/services/api/api_consumer.dart';
import 'package:easyrent/core/services/api/end_points.dart';
import 'package:easyrent/core/services/api/errors/error_model.dart';
import 'package:easyrent/core/services/api/errors/exceptions.dart';
import 'package:easyrent/data/Session/app_session.dart';
import 'package:easyrent/data/models/user_model.dart';
import 'package:easyrent/main.dart';
import 'package:easyrent/presentation/navigation/navigator.dart';
import 'package:easyrent/presentation/views/auth/views/login.dart';
import 'package:easyrent/presentation/views/auth/views/verification_code_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Userrepo {
  Userrepo(this.api);
  final ApiConsumer api;

  //!-----------------------login---------------------------------->
  Future<Either<String, User>> loginUser({
    required String number,
    required String password,
  }) async {
    try {
      final response = await api.get(
        // EndPoints.login,
        "7c80766d-8cae-4594-bc7e-a72ee8739920",
        // data: {
        //   ApiKey.phone: number,
        //   ApiKey.password: password,
        // },
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
      showErrorSnackbar(" exception ${e.errorModel.message}");
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
      final response = await api.get(
          // EndPoints.registerUser,
          "7c80766d-8cae-4594-bc7e-a72ee8739920"
          // data: {
          //   ApiKey.phone: number,
          //   ApiKey.password: password,
          //   ApiKey.userName: userName,
          //   ApiKey.pointsDto: latLang,
          // },
          );
      if (response.statusCode == 200) {
        Get.off(() => const VerificationCodePage());
      }
      showErrorSnackbar("Something went wrong. Please try again later.");
      return const Left('Unexpected error');
    } on ServerException catch (e) {
      debug.e("Exception $e");
      showErrorSnackbar(" exception ${e.errorModel.message}");
      return Left(e.errorModel.message);
    }
  }

//!-----------------------Verify Code---------------------------------->
  Future<Either<String, User>> verifyCode({required int code}) async {
    try {
      final response = await api.get(
        // EndPoints.verifyCode,
        "7c80766d-8cae-4594-bc7e-a72ee8739920",
        // data: {
        //   ApiKey.code: code,
        // },
      );
      if (response.statusCode == 200) {
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
      showErrorSnackbar(" exception ${e.errorModel.message}");

      return Left(e.errorModel.message);
    }
  }

//!-----------------------Get Profile Info ---------------------------------->
  Future<Either<ServerException, User>> getProfile() async {
    try {
      final response = await api.get(
          // "https://run.mocky.io/v3/cd9ce080-4a73-44ce-95d1-e16c399fb7fe", // with image
          "f0a9efb6-22af-4047-9198-3f933d8b2076" //with null image
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
      showErrorSnackbar("Something went wrong. Please try again later.");
      return Left(ServerException(errorModel: ErrorModel(4, e.toString())));
    }
  }

//!-----------------------Log OUt ---------------------------------->
  Future<Either<String, String>> logoutUser() async {
    try {
      final response = await api.get(
        // EndPoints.Logout,
        "7c80766d-8cae-4594-bc7e-a72ee8739920",
      );
      if (response.statusCode == 200) {
        debug.i("Status Code is ${response.statusCode}");
        userPref?.setBool('isLoggedIn', false);
        deleteToken();
        // AppSession().user = null;
        Get.off(() => LoginPage());
      }
      debug.t("User Logged out ");
      return const Right('User Logged Out');
    } on ServerException catch (e) {
      debug.e("Exception $e");
      showErrorSnackbar(" exception ${e.errorModel.message}");
      return Left(e.errorModel.message);
    }
  }
}

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
