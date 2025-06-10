class LoginResponseModel {
  final bool isSuccess;
  final int statusCode;
  final dynamic errors;
  final LoginDataModel? data;

  LoginResponseModel({
    required this.isSuccess,
    required this.statusCode,
    this.errors,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      isSuccess: json['isSuccess'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      errors: json['errors'],
      data: json['data'] != null ? LoginDataModel.fromJson(json['data']) : null,
    );
  }
}

class LoginDataModel {
  final String email;
  final String token;

  LoginDataModel({required this.email, required this.token});

  factory LoginDataModel.fromJson(Map<String, dynamic> json) {
    return LoginDataModel(
      email: json['email'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
