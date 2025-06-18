import 'package:dio/dio.dart';
import 'package:easyrent/core/constants/utils/rawSnackBar.dart';
import 'package:easyrent/core/services/api/errors/error_model.dart';

class ServerException implements Exception {
  final ErrorModel errorModel;

  ServerException({required this.errorModel});
}

void handleDioException(DioException e) {
  String extractMessage(dynamic data) {
    try {
      if (data != null && data is Map<String, dynamic>) {
        return ErrorModel.fromJson(data).message;
      }
    } catch (_) {}
    return "Something went wrong. Please try again.";
  }

  final data = e.response?.data;
  final message = extractMessage(data);

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.badCertificate:
    case DioExceptionType.cancel:
    case DioExceptionType.connectionError:
      showErrorSnackbar(message);
      throw ServerException(errorModel: ErrorModel.fromJson(data ?? {}));

    case DioExceptionType.unknown:
    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode ?? 0;
      switch (statusCode) {
        case 400: // Bad Request
        case 401: // Unauthorized
        case 403: // Forbidden
        case 404: // Not Found
        case 409: // Conflict
        case 422: // Unprocessable Entity
        case 504: // Gateway Timeout / Server Exception
          showErrorSnackbar(message);
          throw ServerException(errorModel: ErrorModel.fromJson(data ?? {}));
        default:
          showErrorSnackbar(message);
          throw ServerException(errorModel: ErrorModel.fromJson(data ?? {}));
      }
  }
}

//! OLD CODE 
// import 'package:dio/dio.dart';
// import 'package:easyrent/core/constants/utils/rawSnackBar.dart';
// import 'package:easyrent/core/services/api/errors/error_model.dart';

// class ServerException implements Exception {
//   final ErrorModel errorModel;

//   ServerException({required this.errorModel});
// }

// void handleDioException(DioException e) {
//   switch (e.type) {
//     case DioExceptionType.connectionTimeout:

//       throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
//     case DioExceptionType.sendTimeout:

//       throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
//     case DioExceptionType.receiveTimeout:

//       throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
//     case DioExceptionType.badCertificate:

//       throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
//     case DioExceptionType.cancel:

//       throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
//     case DioExceptionType.connectionError:
//       throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
//     case DioExceptionType.unknown:
//     case DioExceptionType.badResponse:
//       switch (e.response!.statusCode) {
//         case 400: // bad request
//           throw ServerException(
//               errorModel: ErrorModel.fromJson(e.response!.data));
//         case 401: // unauthorized
//           throw ServerException(
//               errorModel: ErrorModel.fromJson(e.response!.data));
//         case 403: // forbidden
//           throw ServerException(
//               errorModel: ErrorModel.fromJson(e.response!.data));
//         case 404: // not found
//           throw ServerException(
//               errorModel: ErrorModel.fromJson(e.response!.data));
//         case 409: //coefficient
//           throw ServerException(
//               errorModel: ErrorModel.fromJson(e.response!.data));
//         case 422: //unprocessable entity
//           throw ServerException(
//               errorModel: ErrorModel.fromJson(e.response!.data));
//         case 504: //server exception
//       }
//   }
// }
