// lib/data/datasources/doctor_remote_data_source.dart
abstract class DoctorRemoteDataSource {
  Future<bool> registerDoctor(
      String firstName,
      String lastName,
      String email,
      String phone,
      String password,
      String confirmPassword,
      int specialityId,
      );
}