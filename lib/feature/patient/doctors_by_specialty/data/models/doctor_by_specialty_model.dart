class DoctorBySpecialtyModel {
  final int id;
  final String firstName;
  final String lastName;
  final double? rate;
  final String? about;
  final String? profilePic;
  final String? speciality;

  DoctorBySpecialtyModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.rate,
    this.about,
    this.profilePic,
    this.speciality,
  });

  factory DoctorBySpecialtyModel.fromJson(Map<String, dynamic> json) {
    try {
      return DoctorBySpecialtyModel(
        id: json['id'] ?? 0,
        firstName: json['firstName']?.toString() ?? '',
        lastName: json['lastName']?.toString() ?? '',
        rate: json['rate'] != null
            ? double.tryParse(json['rate'].toString())
            : null,
        about: json['about']?.toString(),
        profilePic: json['profilePic']?.toString(),
        speciality: json['speciality']?.toString(),
      );
    } catch (e) {
      print('Error parsing doctor: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
}
