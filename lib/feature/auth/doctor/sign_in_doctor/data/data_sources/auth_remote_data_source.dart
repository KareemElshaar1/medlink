import 'package:dio/dio.dart';

import '../models/login_request.dart';
import '../models/login_response.dart';

abstract class AuthRemoteDataSourceDoctor {
  Future<LoginResponseDoctorModel> login(LoginRequestDoctorModel loginRequest);
}
