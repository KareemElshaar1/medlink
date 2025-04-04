



import '../entities/patient_entities.dart';
import '../repositories/patient_repository.dart';

class RegisterpatientUseCase {
  final PatientRepository repository;

  RegisterpatientUseCase(this.repository);

  Future<void> execute(Patient patient) {
    return repository.registerPatient(patient);
  }
}