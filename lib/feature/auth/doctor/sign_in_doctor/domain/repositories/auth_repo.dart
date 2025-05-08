import '../entities/login_request.dart';
import '../entities/login_response.dart';

abstract class AuthRepositoryDoctor {
  Future<LoginResponseDoctor> login(LoginRequestDoctor loginRequest);
  Future<bool> isLoggedIn();
  Future<void> saveAuthData(LoginDataDoctor data, bool rememberMe);
  Future<void> logout();
  Future<String?> getToken();
  Future<String?> getEmail();
  Future<bool> getRememberMePreference();
  Future<void> clearCache();
}
