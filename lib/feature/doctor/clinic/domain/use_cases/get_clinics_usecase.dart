import '../repositories/clinic_repository.dart';
import '../models/clinic_model.dart';

class GetClinicsUseCase {
  final ClinicRepository repository;

  GetClinicsUseCase(this.repository);

  Future<List<ClinicModel>> call() async {
    return await repository.getClinics();
  }
}
