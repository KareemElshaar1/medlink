import '../repositories/schedule_repository.dart';

class DeleteScheduleUseCase {
  final ScheduleRepository repository;

  DeleteScheduleUseCase(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteSchedule(id);
  }
}
