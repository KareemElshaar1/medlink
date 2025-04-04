
import '../../domain/entities/patient_entities.dart';


abstract class patientRemoteDataSource {
  Future<void> registerPatient(Patient patient);
}