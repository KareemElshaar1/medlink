import '../repositories/schedule_repository.dart';
import '../../data/models/schedule_model.dart';

class GetScheduleUseCase {
  final ScheduleRepository repository;

  GetScheduleUseCase(this.repository);

  Future<List<ScheduleModel>> call() async {
    return await repository.getSchedule();
  }
}
