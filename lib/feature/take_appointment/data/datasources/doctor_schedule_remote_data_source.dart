import 'package:dio/dio.dart';
import '../models/doctor_schedule_model.dart';
import '../models/book_appointment_model.dart';

abstract class DoctorScheduleRemoteDataSource {
  Future<List<DoctorScheduleModel>> getDoctorSchedule(int doctorId);
  Future<void> bookAppointment(BookAppointmentModel appointment);
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
  Future<void> bookAppointment(BookAppointmentModel appointment) async {
    try {
      await dio.post('/api/Patient/BookAppointment',
          data: appointment.toJson());
    } catch (e) {
      throw Exception('Failed to book appointment');
    }
  }
}
