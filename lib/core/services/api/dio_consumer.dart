import 'package:dio/dio.dart';
import 'package:easyrent/core/services/api/api_consumer.dart';
import 'package:easyrent/core/services/api/api_interceptor.dart';
import 'package:easyrent/core/services/api/end_points.dart';
import 'package:easyrent/core/services/api/errors/exceptions.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer(this.dio) {
    // dio.options.queryParameters={"LANG":'En'};  for language
    dio.options.baseUrl = EndPoints.baseUrl;
    dio.interceptors.add(const ApiInterceptor());
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      error: true,
      responseBody: true,
      responseHeader: true,
    ));
  }

  @override
  delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false, 
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  get(String path,
      {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  patch(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      bool isFormData = false}) async {
    try {
      final response = await dio.patch(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  post(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      bool isFormData = false}) async {
    try {
      final response = await dio.post(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }
}
