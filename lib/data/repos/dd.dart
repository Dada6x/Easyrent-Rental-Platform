import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:easyrent/core/services/api/end_points.dart';
import 'package:image_picker/image_picker.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  Future<Either<String, String>> uploadImage(XFile image) async {
    try {
      final fileName = image.path.split('/').last;


      final formData = FormData.fromMap({
        'profileImage': await MultipartFile.fromFile(
          image.path,
          filename: fileName,
        ),
      });

      final response = await dio.post(
        EndPoints.uploadProfileImage, 
        data: {
          "user-image":formData
        },
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        return const Right("Image uploaded successfully");
      } else {
        return Left("Upload failed with status: ${response.statusCode}");
      }
    } catch (e) {
      return Left("Upload error: $e");
    }
  }
}
