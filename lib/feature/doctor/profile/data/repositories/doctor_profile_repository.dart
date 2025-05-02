import 'package:dio/dio.dart';
import '../models/doctor_profile_model.dart';

abstract class DoctorProfileRepository {
  Future<DoctorProfileModel> getDoctorProfile();
}

class DoctorProfileRepositoryImpl implements DoctorProfileRepository {
  final Dio _dio;

  DoctorProfileRepositoryImpl(this._dio);

  @override
  Future<DoctorProfileModel> getDoctorProfile() async {
    try {
      final response = await _dio.get('http://medlink.runasp.net/api/Doctors');
      if (response.statusCode == 200) {
        return DoctorProfileModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Error loading profile: $e');
    }
  }
}
