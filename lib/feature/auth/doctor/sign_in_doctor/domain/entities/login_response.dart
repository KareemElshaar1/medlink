class LoginResponseDoctor {
  final bool isSuccess;
  final int statusCode;
  final dynamic errors;
  final LoginDataDoctor? data;

  LoginResponseDoctor({
    required this.isSuccess,
    required this.statusCode,
    this.errors,
    this.data,
  });
}

class LoginDataDoctor {
  final String email;
  final String token;

  LoginDataDoctor({required this.email, required this.token});
}
