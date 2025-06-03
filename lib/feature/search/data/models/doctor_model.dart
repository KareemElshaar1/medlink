class DoctorModel {
  final int id;
  final String firstName;
  final String lastName;
  final double? rate;
  final String? about;
  final String? profilePic;
  final String speciality;

  DoctorModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.rate,
    this.about,
    this.profilePic,
    required this.speciality,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      rate: json['rate']?.toDouble(),
      about: json['about'],
      profilePic: json['profilePic'],
      speciality: json['speciality'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'rate': rate,
      'about': about,
      'profilePic': profilePic,
      'speciality': speciality,
    };
  }
}
