import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../../../core/helper/shared_pref_helper.dart';
import '../../domain/entities/login_request.dart';
import '../../domain/entities/login_response.dart';
import '../../domain/repositories/auth_repo.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/login_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;
  static const String _tokenKey = 'auth_token';
  static const String _emailKey = 'user_email';
  static const String _rememberMeKey = 'remember_me';

  AuthRepositoryImpl(this.remoteDataSource, this.secureStorage);

  @override
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    final requestModel = LoginRequestModel(
      email: loginRequest.email,
      password: loginRequest.password,
    );

    final response = await remoteDataSource.login(requestModel);

    return LoginResponse(
      isSuccess: response.isSuccess,
      statusCode: response.statusCode,
      errors: response.errors,
      data: response.data != null
          ? LoginData(
              email: response.data!.email,
              token: response.data!.token,
            )
          : null,
    );
  }

  @override
  Future<void> saveAuthData(LoginData data, bool rememberMe) async {
    if (rememberMe) {
      // Save token and email securely only if "Remember Me" is selected
      await SharedPrefHelper.setSecuredString(_tokenKey, data.token);
      await SharedPrefHelper.setSecuredString(_emailKey, data.email);
    } else {
      // Clear token and email if "Remember Me" is not selected
      await SharedPrefHelper.removeData(_tokenKey);
      await SharedPrefHelper.removeData(_emailKey);
    }

    // Save remember me preference
    await SharedPrefHelper.setData(_rememberMeKey, rememberMe);
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await SharedPrefHelper.getSecuredString(_tokenKey);
    return token.isNotEmpty;
  }

  @override
  Future<bool> getRememberMePreference() async {
    return await SharedPrefHelper.getBool(_rememberMeKey);
  }

  @override
  Future<void> logout() async {
    await SharedPrefHelper.removeData(_tokenKey);
    await SharedPrefHelper.removeData(_emailKey);
    await SharedPrefHelper.removeData("is_patient");
    // Keep remember me preference
  }

  @override
  Future<String?> getToken() async {
    return await SharedPrefHelper.getSecuredString(_tokenKey);
  }

  @override
  Future<String?> getEmail() async {
    return await SharedPrefHelper.getSecuredString(_emailKey);
  }
}
