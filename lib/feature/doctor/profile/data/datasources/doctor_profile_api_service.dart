import 'package:dio/dio.dart';
import 'package:medlink/core/interceptors/auth_interceptor.dart';
import '../models/doctor_profile_model.dart';

abstract class DoctorProfileApiService {
  Future<DoctorProfileModel> getDoctorProfile();
  Future<bool> updateDoctorProfile({
    required String firstName,
    required String lastName,
    required String about,
    required String phone,
    String? profilePic,
  });
}

class DoctorProfileApiServiceImpl implements DoctorProfileApiService {
  final Dio _dio;

  DoctorProfileApiServiceImpl(this._dio) {
    _dio.interceptors.add(AuthInterceptor());
  }

  @override
  Future<DoctorProfileModel> getDoctorProfile() async {
    try {
      print('Making GET request to /api/Doctors'); // Debug print
      final response = await _dio.get('http://medlink.runasp.net/api/Doctors');
      print('Response received: ${response.data}'); // Debug print
      return DoctorProfileModel.fromJson(response.data);
    } catch (e) {
      print('API Error: $e'); // Debug print
      throw Exception('Failed to get doctor profile: $e');
    }
  }

  @override
  Future<bool> updateDoctorProfile({
    required String firstName,
    required String lastName,
    required String about,
    required String phone,
    String? profilePic,
  }) async {
    try {
      final formData = FormData.fromMap({
        'firstName': firstName,
        'lastName': lastName,
        'about': about,
        'phone': phone,
      });

      if (profilePic != null) {
        formData.files.add(
          MapEntry(
            'ProfilePic',
            await MultipartFile.fromFile(
              profilePic,
              filename: profilePic.split('/').last,
            ),
          ),
        );
      }

      final response = await _dio.post(
        'http://medlink.runasp.net/api/Doctors',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
        ),
      );

      // Return true if the update was successful
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to update doctor profile: $e');
    }
  }
}
