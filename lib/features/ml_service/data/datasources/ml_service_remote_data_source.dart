import 'package:dio/dio.dart';
import '../models/dosage_prediction_model.dart';
import '../models/patient_data_model.dart';

abstract class MLServiceRemoteDataSource {
  Future<DosagePredictionModel> predictDosage(PatientDataModel patientData);
  Future<List<String>> getAvailableDrugs();
}

class MLServiceRemoteDataSourceImpl implements MLServiceRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  MLServiceRemoteDataSourceImpl({
    required this.dio,
    this.baseUrl = 'http://localhost:8000',
  });

  @override
  Future<DosagePredictionModel> predictDosage(
      PatientDataModel patientData) async {
    try {
      final response = await dio.post(
        '$baseUrl/predict',
        data: patientData.toJson(),
      );

      if (response.statusCode == 200) {
        return DosagePredictionModel.fromJson(response.data);
      } else {
        throw Exception('Failed to predict dosage');
      }
    } catch (e) {
      throw Exception('Error predicting dosage: $e');
    }
  }

  @override
  Future<List<String>> getAvailableDrugs() async {
    try {
      final response = await dio.get('$baseUrl/drugs');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return List<String>.from(data['drugs']);
      } else {
        throw Exception('Failed to get available drugs');
      }
    } catch (e) {
      throw Exception('Error getting available drugs: $e');
    }
  }
}
