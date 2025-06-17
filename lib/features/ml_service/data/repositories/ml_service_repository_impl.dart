import '../../domain/repositories/ml_service_repository.dart';
import '../datasources/ml_service_remote_data_source.dart';
import '../models/dosage_prediction_model.dart';
import '../models/patient_data_model.dart';

class MLServiceRepositoryImpl implements MLServiceRepository {
  final MLServiceRemoteDataSource remoteDataSource;

  MLServiceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DosagePredictionModel> predictDosage(
      PatientDataModel patientData) async {
    try {
      return await remoteDataSource.predictDosage(patientData);
    } catch (e) {
      throw Exception('Failed to predict dosage: $e');
    }
  }

  @override
  Future<List<String>> getAvailableDrugs() async {
    try {
      return await remoteDataSource.getAvailableDrugs();
    } catch (e) {
      throw Exception('Failed to get available drugs: $e');
    }
  }
}
