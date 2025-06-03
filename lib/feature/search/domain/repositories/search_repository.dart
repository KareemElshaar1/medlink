import '../../data/models/doctor_model.dart';

abstract class SearchRepository {
  Future<List<DoctorModel>> searchDoctors(String query);
}
