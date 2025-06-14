import 'package:dio/dio.dart';

import '../models/login_request.dart';
import '../models/login_response.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceDoctorImpl implements AuthRemoteDataSourceDoctor {
  final Dio dio;

  AuthRemoteDataSourceDoctorImpl(this.dio);

  @override
  Future<LoginResponseDoctorModel> login(
      LoginRequestDoctorModel loginRequest) async {
    try {
      final response = await dio.post(
        '/Auth/doc/Login',
        data: loginRequest.toJson(),
      );
      return LoginResponseDoctorModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return LoginResponseDoctorModel(
          isSuccess: false,
          statusCode: e.response?.statusCode ?? 500,
          errors: e,
        );
      }
      return LoginResponseDoctorModel(
        isSuccess: false,
        statusCode: 500,
        errors: 'Network error occurred',
      );
    } catch (e) {
      return LoginResponseDoctorModel(
        isSuccess: false,
        statusCode: 500,
        errors: 'Unexpected error occurred',
      );
    }
  }
}
