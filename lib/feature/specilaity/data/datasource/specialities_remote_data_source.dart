// lib/data/datasources/specialities_remote_data_source.dart

import '../../domain/entities/speciality_entity.dart';

abstract class SpecialitiesRemoteDataSource {
  Future<List<Speciality>> getSpecialities();
}
