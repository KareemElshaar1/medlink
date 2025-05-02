// lib/domain/repositories/doctor_repository.dart
abstract class DoctorRepository {
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
