// lib/domain/repositories/specialities_repository.dart

import '../entities/speciality_entity.dart';

abstract class SpecialitiesRepository {
  Future<List<Speciality>> getSpecialities();
}
