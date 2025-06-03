import '../../domain/repositories/search_repository.dart';
import '../models/doctor_model.dart';
import '../datasources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<DoctorModel>> searchDoctors(String query) async {
    return await remoteDataSource.searchDoctors(query);
  }
}
