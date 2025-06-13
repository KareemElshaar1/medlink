import '../../../../doctor/sign_up_doctor/domain/entities/doctor_entity.dart';
import '../entities/patient_entities.dart';

abstract class PatientRepository {
  Future<void> registerPatient(Patient patient);
}
