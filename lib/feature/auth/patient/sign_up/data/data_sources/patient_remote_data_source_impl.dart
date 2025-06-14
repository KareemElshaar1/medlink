import 'package:dio/dio.dart';
import 'package:medlink/feature/auth/patient/sign_up/data/data_sources/patient_remote_data_source.dart';

import '../../domain/entities/patient_entities.dart';

class PatientRemoteDataSourceImpl implements patientRemoteDataSource {
  final Dio dio;

  PatientRemoteDataSourceImpl(this.dio);

  @override
  Future<void> registerPatient(Patient patient) async {
    try {
      final response = await dio.post(
        '/Auth/user/SignUp',
        data: patient.toJson(),
      );

      if (response.statusCode == 200 && response.data['isSuccess'] == true) {
        return; // Success
      }

      throw Exception('Registration failed: ${response.data['errors']}');
    } on DioException catch (e) {
      // Pass through the DioException to be handled by the cubit
      rethrow;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<void> registerDoctor(Patient patient) {
    // TODO: implement registerDoctor
    throw UnimplementedError();
  }
}
