import 'package:dio/dio.dart';
import '../models/doctor_schedule_model.dart';
import '../models/book_appointment_model.dart';

abstract class DoctorScheduleRemoteDataSource {
  Future<List<DoctorScheduleModel>> getDoctorSchedule(int doctorId);
  Future<int> bookAppointment(BookAppointmentModel appointment);
}

class DoctorScheduleRemoteDataSourceImpl
    implements DoctorScheduleRemoteDataSource {
  final Dio dio;

  DoctorScheduleRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<DoctorScheduleModel>> getDoctorSchedule(int doctorId) async {
    try {
      final response = await dio.get('/api/Patient/GetDoctorSchedule',
          queryParameters: {'id': doctorId});
      return (response.data as List)
          .map((json) => DoctorScheduleModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get doctor schedule');
    }
  }

  @override
  Future<int> bookAppointment(BookAppointmentModel appointment) async {
    try {
      final response = await dio.post('/api/Patient/BookAppointment',
          data: appointment.toJson());

      if (response.statusCode == 204) {
        // For 204 No Content, we'll return a temporary ID
        // You might want to adjust this based on your API's behavior
        return 0;
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['id'] as int;
      } else {
        throw Exception(
            'Failed to book appointment: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            'Failed to book appointment: ${e.response?.data['message'] ?? e.message}');
      }
      throw Exception('Failed to book appointment: ${e.message}');
    } catch (e) {
      throw Exception('Failed to book appointment: $e');
    }
  }
}
