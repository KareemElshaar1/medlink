import '../models/clinic_model.dart';
import '../models/governate_model.dart';
import '../models/city_model.dart';
import '../models/speciality_model.dart';

abstract class ClinicRepository {
  Future<bool> addClinic(ClinicModel clinic);
  Future<List<GovernateModel>> getGovernates();
  Future<List<CityModel>> getCities(int governateId);
  Future<List<SpecialityModel>> getSpecialities();
  Future<List<ClinicModel>> getClinics();
}
