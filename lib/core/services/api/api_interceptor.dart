import 'package:dio/dio.dart';
import 'package:easyrent/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiInterceptor extends Interceptor {
  const ApiInterceptor();

  Future<String?> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _loadToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      // options.headers['Authorization'] = 'Bearer $Null';
      debug.i('No token found in SharedPreferences.');
    }

    options.headers['Accept'] = 'application/json';

    super.onRequest(options, handler);
  }
}
