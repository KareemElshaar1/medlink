class RecommendationDoctor {
  final int id;
  final String firstName;
  final String lastName;
  final double? rate;
  final String? about;
  final String? profilePic;
  final String speciality;

  RecommendationDoctor({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.rate,
    this.about,
    this.profilePic,
    required this.speciality,
  });
}
