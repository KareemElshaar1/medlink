import 'package:dio/dio.dart';
import '../models/patient_profile_model.dart';

abstract class PatientProfileRemoteDataSource {
  Future<PatientProfileModel> getProfile();
  Future<PatientProfileModel> updateProfile({
    required String name,
    required String phone,
    String? profilePic,
  });
}

class PatientProfileRemoteDataSourceImpl
    implements PatientProfileRemoteDataSource {
  final Dio dio;

  PatientProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<PatientProfileModel> getProfile() async {
    try {
      final response = await dio.get('http://medlink.runasp.net/api/Patient');
      return PatientProfileModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  @override
  Future<PatientProfileModel> updateProfile({
    required String name,
    required String phone,
    String? profilePic,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'phone': phone,
        if (profilePic != null)
          'profilePic': await MultipartFile.fromFile(profilePic),
      });

      await dio.post(
        'http://medlink.runasp.net/api/Patient/EditUserProfile',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
        ),
      );

      // After successful update, fetch the updated profile
      return await getProfile();
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
