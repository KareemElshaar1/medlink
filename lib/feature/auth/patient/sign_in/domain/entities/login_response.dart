class LoginResponse {
  final bool isSuccess;
  final int statusCode;
  final dynamic errors;
  final LoginData? data;

  LoginResponse({
    required this.isSuccess,
    required this.statusCode,
    this.errors,
    this.data,
  });
}

class LoginData {
  final String email;
  final String token;

  LoginData({required this.email, required this.token});
}