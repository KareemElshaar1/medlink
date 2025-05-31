import '../entities/recommendation_doctor.dart';
import '../repositories/recommendation_doctor_repository.dart';

class GetRecommendationDoctorsUseCase {
  final RecommendationDoctorRepository repository;

  GetRecommendationDoctorsUseCase(this.repository);

  Future<List<RecommendationDoctor>> call() async {
    return await repository.getRecommendationDoctors();
  }
}
