import 'package:dio/dio.dart';
import '../helper/shared_pref_helper.dart';

class AuthInterceptor extends Interceptor {
  static const String _patientTokenKey = 'patient_auth_token';
  static const String _doctorTokenKey = 'doctor_auth_token';

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Try to get both tokens
    final patientToken =
        await SharedPrefHelper.getSecuredString(_patientTokenKey);
    final doctorToken =
        await SharedPrefHelper.getSecuredString(_doctorTokenKey);

    print('AuthInterceptor: Patient Token = $patientToken'); // Debug log
    print('AuthInterceptor: Doctor Token = $doctorToken'); // Debug log

    // Determine which token to use based on the request URL or headers
    String? token;
    if (options.path.contains('/doctor/') ||
        options.path.contains('/doctors/')) {
      token = doctorToken;
    } else if (options.path.contains('/patient/') ||
        options.path.contains('/patients/')) {
      token = patientToken;
    } else {
      // If path doesn't indicate user type, try both tokens
      token = doctorToken.isNotEmpty ? doctorToken : patientToken;
    }

    if (token?.isNotEmpty ?? false) {
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
