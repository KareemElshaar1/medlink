import '../models/clinic_model.dart';
import '../repositories/clinic_repository.dart';

class AddClinicUseCase {
  final ClinicRepository repository;

  AddClinicUseCase(this.repository);

  Future<bool> call(ClinicModel clinic) {
    return repository.addClinic(clinic);
  }
}
