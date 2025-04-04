import 'package:dio/dio.dart';

import '../models/login_request.dart';
import '../models/login_response.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<LoginResponseModel> login(LoginRequestModel loginRequest) async {
    try {
      final response = await dio.post(
        '/Auth/User/Login',
        data: loginRequest.toJson(),
      );
      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return LoginResponseModel(
          isSuccess: false,
          statusCode: e.response?.statusCode ?? 500,
          errors: e.response?.data['errors'] ?? 'Unknown error occurred',
        );
      }
      return LoginResponseModel(
        isSuccess: false,
        statusCode: 500,
        errors: 'Network error occurred',
      );
    } catch (e) {
      return LoginResponseModel(
        isSuccess: false,
        statusCode: 500,
        errors: 'Unexpected error occurred',
      );
    }
  }
}