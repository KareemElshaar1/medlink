import '../../data/models/patient_profile_model.dart';

abstract class PatientProfileRepository {
  Future<PatientProfileModel> getProfile();
  Future<PatientProfileModel> updateProfile({
    required String name,
    required String phone,
    String? profilePic,
  });
}
