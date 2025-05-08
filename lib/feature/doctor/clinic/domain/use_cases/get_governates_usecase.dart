import '../../data/models/governate_model.dart';
import '../repositories/clinic_repository.dart';

class GetGovernatesUseCase {
  final ClinicRepository repository;

  GetGovernatesUseCase(this.repository);

  Future<List<GovernateModel>> call() {
    return repository.getGovernates();
  }
}
