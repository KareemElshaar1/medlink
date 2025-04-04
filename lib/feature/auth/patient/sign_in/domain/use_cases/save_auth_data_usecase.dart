import '../entities/login_response.dart';
import '../repositories/auth_repo.dart';

class SaveAuthDataUseCase {
  final AuthRepository repository;

  SaveAuthDataUseCase(this.repository);

  Future<void> call(LoginData data, bool rememberMe) {
    return repository.saveAuthData(data, rememberMe);
  }
}

