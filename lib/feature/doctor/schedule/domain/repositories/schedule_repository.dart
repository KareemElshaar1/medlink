import '../../data/models/clinic_model.dart';
import '../../data/models/schedule_model.dart';

abstract class ScheduleRepository {
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
