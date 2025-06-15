import 'package:dio/dio.dart';
import '../../domain/entities/recommendation_doctor.dart';
import '../../domain/repositories/recommendation_doctor_repository.dart';
import '../data_sources/recommendation_doctor_remote_data_source.dart';
import '../models/recommendation_doctor_model.dart';

class RecommendationDoctorRepositoryImpl
    implements RecommendationDoctorRepository {
  final RecommendationDoctorRemoteDataSource remoteDataSource;

  RecommendationDoctorRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<RecommendationDoctor>> getRecommendationDoctors() async {
    try {
      final response = await remoteDataSource.getRecommendationDoctors();
      if (response.statusCode == 200) {
        final List<dynamic> doctorsJson = response.data;
        print('API Response for doctors: $doctorsJson'); // Debug log
        return doctorsJson
            .map((json) => RecommendationDoctorModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
            'Failed to get recommendation doctors: ${response.statusCode}');
      }
    } catch (e) {
      print('Repository error: $e');
      throw Exception('Failed to get recommendation doctors');
    }
  }
}
