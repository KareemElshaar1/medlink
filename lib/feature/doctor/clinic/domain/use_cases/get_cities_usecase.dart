import '../../data/models/city_model.dart';
import '../repositories/clinic_repository.dart';

class GetCitiesUseCase {
  final ClinicRepository repository;

  GetCitiesUseCase(this.repository);

  Future<List<CityModel>> call(int governateId) {
    return repository.getCities(governateId);
  }
}
