

import '../../domain/entities/patient_entities.dart';
import '../../domain/repositories/patient_repository.dart';
import '../data_sources/patient_remote_data_source.dart';

class PatientRepositoryImpl implements PatientRepository {
  final patientRemoteDataSource remoteDataSource;

  PatientRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> registerPatient(Patient patient) {
    return remoteDataSource.registerPatient(patient);
  }
}