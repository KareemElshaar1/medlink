class DoctorProfileModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String about;
  final double? rate;
  final String? profilePic;

  DoctorProfileModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.about,
    this.rate,
    this.profilePic,
  });

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    return DoctorProfileModel(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      about: json['about'] ?? '',
      rate: json['rate']?.toDouble(),
      profilePic: json['profilePic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'about': about,
      'rate': rate,
      'profilePic': profilePic,
    };
  }
}
