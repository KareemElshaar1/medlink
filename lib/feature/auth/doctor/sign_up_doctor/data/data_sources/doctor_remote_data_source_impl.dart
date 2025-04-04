// lib/data/datasources/doctor_remote_data_source_impl.dart
import 'package:dio/dio.dart';
import 'doctor_remote_data_source.dart';

class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  final Dio dio;

  DoctorRemoteDataSourceImpl(this.dio);

  @override
  Future<bool> registerDoctor(
      String firstName,
      String lastName,
      String email,
      String phone,
      String password,
      String confirmPassword,
      int specialityId,
      ) async {
    try {
      final userData = {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "password": password,
        "confirmPassword": confirmPassword,
        "specialityId": specialityId,
      };

      final response = await dio.post(
        '/Auth/doc/SignUp',
        data: userData,
      );

      if (response.statusCode == 200) {
        return response.data['isSuccess'] == true;
      }

      return false;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
}