import '../../domain/repositories/patient_profile_repository.dart';
import '../../data/models/patient_profile_model.dart';
import '../datasources/patient_profile_remote_data_source.dart';

class PatientProfileRepositoryImpl implements PatientProfileRepository {
  final PatientProfileRemoteDataSource remoteDataSource;

  PatientProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<PatientProfileModel> getProfile() async {
    try {
      return await remoteDataSource.getProfile();
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  @override
  Future<PatientProfileModel> updateProfile({
    required String name,
    required String phone,
    String? profilePic,
  }) async {
    try {
      return await remoteDataSource.updateProfile(
        name: name,
        phone: phone,
        profilePic: profilePic,
      );
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
