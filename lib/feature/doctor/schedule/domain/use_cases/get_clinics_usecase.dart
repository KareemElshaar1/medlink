import '../repositories/schedule_repository.dart';
import '../../data/models/clinic_model.dart';

class GetScheduleClinicsUseCase {
  final ScheduleRepository repository;

  GetScheduleClinicsUseCase(this.repository);

  Future<List<ClinicModel>> call() async {
    return await repository.getClinics();
  }
}
