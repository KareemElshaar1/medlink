import 'package:dio/dio.dart';
import '../models/clinic_model.dart';
import '../models/schedule_model.dart';
import 'schedule_remote_data_source.dart';

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final Dio dio;

  ScheduleRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ClinicModel>> getClinics() async {
    final response = await dio.get('/api/Doctors/Clinics');
    return (response.data as List)
        .map((json) => ClinicModel.fromJson(json))
        .toList();
  }

  @override
  Future<void> createSchedule({
    required String day,
    required String appointmentStart,
    required String appointmentEnd,
    required int clinicId,
  }) async {
    await dio.post('/api/Schedule/CreateSchedule', data: {
      'day': day,
      'appointmentStart': appointmentStart,
      'appointmentEnd': appointmentEnd,
      'clinicId': clinicId,
    });
  }

  @override
  Future<List<ScheduleModel>> getSchedule() async {
    final response = await dio.get('/api/Schedule/GetSchedule');
    return (response.data as List)
        .map((json) => ScheduleModel.fromJson(json))
        .toList();
  }

  @override
  Future<void> deleteSchedule(int id) async {
    await dio.post('/api/Schedule/DeleteSchedule', queryParameters: {'id': id});
  }

  @override
  Future<void> editSchedule({
    required int id,
    required String day,
    required String appointmentStart,
    required String appointmentEnd,
    required int clinicId,
  }) async {
    await dio.post('/api/Schedule/EditSchedule/$id', data: {
      'day': day,
      'appointmentStart': appointmentStart,
      'appointmentEnd': appointmentEnd,
      'clinicId': clinicId,
    });
  }
}
