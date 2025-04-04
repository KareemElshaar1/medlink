import '../repositories/auth_repo.dart';

class CheckAuthStatusDoctorUseCase {
  final AuthRepositoryDoctor repository;

  CheckAuthStatusDoctorUseCase(this.repository);

  Future<bool> call() {
    return repository.isLoggedIn();
  }
}