import 'package:dio/dio.dart';
import '../models/appointment_model.dart';

abstract class AppointmentApiService {
  Future<List<AppointmentModel>> getAppointments();
}

class AppointmentApiServiceImpl implements AppointmentApiService {
  final Dio _dio;

  AppointmentApiServiceImpl(this._dio);

  @override
  Future<List<AppointmentModel>> getAppointments() async {
    try {
      final response = await _dio.get('/api/Schedule/GetAppointments');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => AppointmentModel.fromJson(json)).toList();
      }
      throw Exception('Failed to load appointments');
    } catch (e) {
      throw Exception('Failed to load appointments: $e');
    }
  }
}
