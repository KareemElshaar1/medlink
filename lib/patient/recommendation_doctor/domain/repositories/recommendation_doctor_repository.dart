import '../entities/recommendation_doctor.dart';

abstract class RecommendationDoctorRepository {
  Future<List<RecommendationDoctor>> getRecommendationDoctors();
}
