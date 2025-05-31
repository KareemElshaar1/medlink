import '../repositories/schedule_repository.dart';

class EditScheduleUseCase {
  final ScheduleRepository repository;

  EditScheduleUseCase(this.repository);

  Future<void> call({
    required int id,
    required String day,
    required String appointmentStart,
    required String appointmentEnd,
    required int clinicId,
  }) async {
    return await repository.editSchedule(
      id: id,
      day: day,
      appointmentStart: appointmentStart,
      appointmentEnd: appointmentEnd,
      clinicId: clinicId,
    );
  }
}
