class Patient {
  final String name;
  final String birthDate;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;

  Patient({
    required this.name,
    required this.birthDate,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthDate': birthDate,
      'email': email,
      'phone': phone,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}