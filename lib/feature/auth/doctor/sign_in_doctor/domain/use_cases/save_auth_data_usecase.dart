import '../entities/login_response.dart';
import '../repositories/auth_repo.dart';

class SaveAuthDataDoctorUseCase {
  final AuthRepositoryDoctor repository;

  SaveAuthDataDoctorUseCase(this.repository);

  Future<void> call(LoginDataDoctor data, bool rememberMe) {
    return repository.saveAuthData(data, rememberMe);
  }
}

