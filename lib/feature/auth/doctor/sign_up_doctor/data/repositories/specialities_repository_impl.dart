// lib/data/repositories/specialities_repository_impl.dart
import '../../domain/entities/speciality_entity.dart';
import '../../domain/repositories/specialities_repository.dart';
import '../data_sources/specialities_remote_data_source.dart';

class SpecialitiesRepositoryImpl implements SpecialitiesRepository {
  final SpecialitiesRemoteDataSource remoteDataSource;

  SpecialitiesRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Speciality>> getSpecialities() {
    return remoteDataSource.getSpecialities();
  }
}
