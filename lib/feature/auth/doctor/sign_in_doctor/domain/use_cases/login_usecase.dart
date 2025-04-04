import '../entities/login_request.dart';
import '../entities/login_response.dart';
import '../repositories/auth_repo.dart';

class LoginUseCaseDoctor {
  final AuthRepositoryDoctor repository;

  LoginUseCaseDoctor(this.repository);

  Future<LoginResponseDoctor> call(LoginRequestDoctor params) {
    return repository.login(params);
  }
}