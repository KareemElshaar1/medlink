import '../../domain/entities/recommendation_doctor.dart';

class RecommendationDoctorModel extends RecommendationDoctor {
  RecommendationDoctorModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    super.rate,
    super.about,
    super.profilePic,
    required super.speciality,
  });

  factory RecommendationDoctorModel.fromJson(Map<String, dynamic> json) {
    return RecommendationDoctorModel(
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
