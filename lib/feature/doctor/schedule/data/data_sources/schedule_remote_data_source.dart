import 'package:dio/dio.dart';
import '../models/clinic_model.dart';
import '../models/schedule_model.dart';

abstract class ScheduleRemoteDataSource {
  Future<List<ClinicModel>> getClinics();
  Future<void> createSchedule({
    required String day,
    required String appointmentStart,
    required String appointmentEnd,
    required int clinicId,
  });
  Future<List<ScheduleModel>> getSchedule();
  Future<void> deleteSchedule(int id);
  Future<void> editSchedule({
    required int id,
    required String day,
    required String appointmentStart,
    required String appointmentEnd,
    required int clinicId,
  });
}
