import '../../data/models/speciality_model.dart';
import '../repositories/clinic_repository.dart';

class GetSpecialitieUseCase {
  final ClinicRepository repository;

  GetSpecialitieUseCase(this.repository);

  Future<List<SpecialityModel>> call() {
    return repository.getSpecialities();
  }
}
