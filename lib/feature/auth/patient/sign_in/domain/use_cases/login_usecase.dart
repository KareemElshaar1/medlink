import '../entities/login_request.dart';
import '../entities/login_response.dart';
import '../repositories/auth_repo.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<LoginResponse> call(LoginRequest params) {
    return repository.login(params);
  }
}