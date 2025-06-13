import 'package:dio/dio.dart';

abstract class RecommendationDoctorRemoteDataSource {
  Future<Response> getRecommendationDoctors();
}

class RecommendationDoctorRemoteDataSourceImpl
    implements RecommendationDoctorRemoteDataSource {
  final Dio dio;

  RecommendationDoctorRemoteDataSourceImpl(this.dio);

  @override
  Future<Response> getRecommendationDoctors() async {
    try {
      return await dio.get('/api/Patient/GetDoctors');
    } catch (e) {
      print('Error fetching doctors: $e');
      rethrow;
    }
  }
}
