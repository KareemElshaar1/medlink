// lib/domain/repositories/specialities_repository.dart
import 'package:medlink/feature/specilaity/domain/entities/speciality_entity.dart';

abstract class SpecialitiesRepository {
  Future<List<Speciality>> getSpecialities();
}
