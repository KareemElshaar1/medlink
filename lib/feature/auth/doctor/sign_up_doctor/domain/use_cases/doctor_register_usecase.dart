// lib/domain/usecases/doctor_register_usecase.dart
import '../repositories/doctor_repository.dart';

abstract class DoctorRegisterUseCase {
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

class RegisterDoctorUseCase implements DoctorRegisterUseCase {
  final DoctorRepository repository;

  RegisterDoctorUseCase(this.repository);

  @override
  Future<bool> registerDoctor(
      String firstName,
      String lastName,
      String email,
      String phone,
      String password,
      String confirmPassword,
      int specialityId,
      ) {
    return repository.registerDoctor(
      firstName,
      lastName,
      email,
      phone,
      password,
      confirmPassword,
      specialityId,
    );
  }
}