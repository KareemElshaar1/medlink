import '../entities/doctor_schedule.dart';
import '../repositories/doctor_schedule_repository.dart';

class GetDoctorScheduleUseCase {
  final DoctorScheduleRepository repository;

  GetDoctorScheduleUseCase({required this.repository});

  Future<List<DoctorSchedule>> call(int doctorId) async {
    return await repository.getDoctorSchedule(doctorId);
  }
}
