import '../../data/models/dosage_prediction_model.dart';
import '../../data/models/patient_data_model.dart';

abstract class MLServiceRepository {
  Future<DosagePredictionModel> predictDosage(PatientDataModel patientData);
  Future<List<String>> getAvailableDrugs();
}
