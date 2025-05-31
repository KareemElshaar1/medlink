import '../../domain/repositories/schedule_repository.dart';
import '../data_sources/schedule_remote_data_source.dart';
import '../models/clinic_model.dart';
import '../models/schedule_model.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  ScheduleRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ClinicModel>> getClinics() async {
    return await remoteDataSource.getClinics();
  }

  @override
  Future<void> createSchedule({
    required String day,
    required String appointmentStart,
    required String appointmentEnd,
    required int clinicId,
  }) async {
    await remoteDataSource.createSchedule(
      day: day,
      appointmentStart: appointmentStart,
      appointmentEnd: appointmentEnd,
      clinicId: clinicId,
    );
  }

  @override
  Future<List<ScheduleModel>> getSchedule() async {
    return await remoteDataSource.getSchedule();
  }

  @override
  Future<void> deleteSchedule(int id) async {
    await remoteDataSource.deleteSchedule(id);
  }

  @override
  Future<void> editSchedule({
    required int id,
    required String day,
    required String appointmentStart,
    required String appointmentEnd,
    required int clinicId,
  }) async {
    await remoteDataSource.editSchedule(
      id: id,
      day: day,
      appointmentStart: appointmentStart,
      appointmentEnd: appointmentEnd,
      clinicId: clinicId,
    );
  }
}
