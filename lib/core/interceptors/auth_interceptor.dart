import 'package:dio/dio.dart';
import '../helper/shared_pref_helper.dart';

class AuthInterceptor extends Interceptor {
  static const String _tokenKey = 'patient_auth_token';

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SharedPrefHelper.getSecuredString(_tokenKey);
    print('AuthInterceptor: Token = $token'); // Debug log

    if (token.isNotEmpty) {
      // Add token to all requests
      options.headers['Authorization'] = 'Bearer $token';
    }

    // For POST requests with FormData (file uploads)
    if (options.method == 'POST' && options.data is FormData) {
      options.headers['Content-Type'] = 'multipart/form-data';
    } else {
      options.headers['Content-Type'] = 'application/json';
    }

    print('AuthInterceptor: Headers = ${options.headers}'); // Debug log
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('AuthInterceptor: Error = ${err.message}'); // Debug log
    print('AuthInterceptor: Response = ${err.response?.data}'); // Debug log

    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      // Handle unauthorized/forbidden error
      print(
          'AuthInterceptor: Unauthorized/Forbidden access - Token may be invalid or expired');
      // You might want to logout the user or refresh the token here
    }
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        'AuthInterceptor: Response Status = ${response.statusCode}'); // Debug log
    print('AuthInterceptor: Response Data = ${response.data}'); // Debug log
    handler.next(response);
  }
}
