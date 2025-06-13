import 'package:dio/dio.dart';
import '../models/doctor_by_specialty_model.dart';

abstract class DoctorsBySpecialtyRemoteDataSource {
  Future<List<DoctorBySpecialtyModel>> getDoctorsBySpecialty(int specialtyId);
  Future<List<DoctorBySpecialtyModel>> getAllDoctors();
}

class DoctorsBySpecialtyRemoteDataSourceImpl
    implements DoctorsBySpecialtyRemoteDataSource {
  final Dio dio;

  DoctorsBySpecialtyRemoteDataSourceImpl(this.dio);

  @override
  Future<List<DoctorBySpecialtyModel>> getDoctorsBySpecialty(
      int specialtyId) async {
    try {
      final response =
          await dio.get('/api/Patient/Doctors/Specialization/$specialtyId');
      print('API Response: ${response.data}'); // Debug log

      if (response.data == null) {
        return [];
      }

      final List<dynamic> data = response.data as List;
      return data.map((json) {
        print('Processing doctor: $json'); // Debug log
        return DoctorBySpecialtyModel.fromJson(json);
      }).toList();
    } catch (e) {
      print('Error fetching doctors: $e'); // Debug log
      throw Exception('Failed to fetch doctors by specialty: $e');
    }
  }

  @override
  Future<List<DoctorBySpecialtyModel>> getAllDoctors() async {
    try {
      final response = await dio.get('/api/Patient/GetDoctors');
      print('API Response: ${response.data}'); // Debug log

      if (response.data == null) {
        return [];
      }

      final List<dynamic> data = response.data as List;
      return data.map((json) {
        print('Processing doctor: $json'); // Debug log
        return DoctorBySpecialtyModel.fromJson(json);
      }).toList();
    } catch (e) {
      print('Error fetching all doctors: $e'); // Debug log
      throw Exception('Failed to fetch all doctors: $e');
    }
  }
}
