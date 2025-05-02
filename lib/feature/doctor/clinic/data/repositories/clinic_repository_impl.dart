import '../../domain/repositories/clinic_repository.dart';
import '../../domain/models/clinic_model.dart';
import '../../domain/models/governate_model.dart';
import '../../domain/models/city_model.dart';
import '../../domain/models/speciality_model.dart';
import '../datasources/clinic_remote_data_source.dart';

class ClinicRepositoryImpl implements ClinicRepository {
  final ClinicRemoteDataSource remoteDataSource;

  ClinicRepositoryImpl(this.remoteDataSource);

  @override
  Future<bool> addClinic(ClinicModel clinic) async {
    try {
      return await remoteDataSource.addClinic(clinic);
    } catch (e) {
      throw Exception('Failed to add clinic: ${e.toString()}');
    }
  }

  @override
  Future<List<GovernateModel>> getGovernates() async {
    try {
      return await remoteDataSource.getGovernates();
    } catch (e) {
      throw Exception('Failed to get governates: ${e.toString()}');
    }
  }

  @override
  Future<List<CityModel>> getCities(int governateId) async {
    try {
      return await remoteDataSource.getCities(governateId);
    } catch (e) {
      throw Exception('Failed to get cities: ${e.toString()}');
    }
  }

  @override
  Future<List<SpecialityModel>> getSpecialities() async {
    try {
      return await remoteDataSource.getSpecialities();
    } catch (e) {
      throw Exception('Failed to get specialities: ${e.toString()}');
    }
  }

  @override
  Future<List<ClinicModel>> getClinics() async {
    try {
      return await remoteDataSource.getClinics();
    } catch (e) {
      throw Exception('Failed to get clinics: ${e.toString()}');
    }
  }
}
