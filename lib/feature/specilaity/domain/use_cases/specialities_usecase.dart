// lib/domain/usecases/specialities_usecase.dart
import 'package:medlink/feature/specilaity/domain/entities/speciality_entity.dart';

 import '../repositories/specialities_repository.dart';

abstract class SpecialitiesUseCase {
  Future<List<Speciality>> getSpecialities();
}

class GetSpecialitiesUseCase implements SpecialitiesUseCase {
  final SpecialitiesRepository repository;

  GetSpecialitiesUseCase(this.repository);

  @override
  Future<List<Speciality>> getSpecialities() {
    return repository.getSpecialities();
  }
}
