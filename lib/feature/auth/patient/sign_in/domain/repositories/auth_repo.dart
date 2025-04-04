import '../entities/login_request.dart';
import '../entities/login_response.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(LoginRequest loginRequest);
  Future<bool> isLoggedIn();
  Future<void> saveAuthData(LoginData data, bool rememberMe);
  Future<void> logout();
  Future<String?> getToken();
  Future<String?> getEmail();
  Future<bool> getRememberMePreference();
}