class LoginRequestDoctorModel {
  final String email;
  final String password;

  LoginRequestDoctorModel({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}