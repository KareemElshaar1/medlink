class PatientProfileModel {
  final String name;
  final String email;
  final String phone;
  final String? profilePic;

  PatientProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    this.profilePic,
  });

  factory PatientProfileModel.fromJson(Map<String, dynamic> json) {
    return PatientProfileModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profilePic: json['profilePic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'profilePic': profilePic,
    };
  }
}
