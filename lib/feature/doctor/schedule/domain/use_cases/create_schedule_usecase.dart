import '../repositories/schedule_repository.dart';

class CreateScheduleUseCase {
  final ScheduleRepository repository;

  CreateScheduleUseCase(this.repository);

  Future<void> call({
    required String day,
    required String appointmentStart,
    required String appointmentEnd,
    required int clinicId,
  }) async {
    await repository.createSchedule(
      day: day,
      appointmentStart: appointmentStart,
      appointmentEnd: appointmentEnd,
      clinicId: clinicId,
    );
  }
}
