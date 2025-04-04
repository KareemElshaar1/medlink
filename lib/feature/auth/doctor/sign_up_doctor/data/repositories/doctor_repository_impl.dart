// lib/data/repositories/doctor_repository_impl.dart
import '../../domain/repositories/doctor_repository.dart';
import '../data_sources/doctor_remote_data_source.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorRemoteDataSource remoteDataSource;

  DoctorRepositoryImpl(this.remoteDataSource);

  @override
  Future<bool> registerDoctor(
      String firstName,
      String lastName,
      String email,
      String phone,
      String password,
      String confirmPassword,
      int specialityId,
      ) {
    return remoteDataSource.registerDoctor(
      firstName,
      lastName,
      email,
      phone,
      password,
      confirmPassword,
      specialityId,
    );
  }
}