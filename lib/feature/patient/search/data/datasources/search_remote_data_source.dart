import 'package:dio/dio.dart';
import '../models/doctor_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<DoctorModel>> searchDoctors(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<DoctorModel>> searchDoctors(String query) async {
    try {
      final response = await dio.get(
        '/api/Patient/GetDoctor',
        queryParameters: {'docName': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => DoctorModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search doctors');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized access');
      } else if (e.response?.statusCode == 404) {
        throw Exception('No doctors found');
      } else {
        throw Exception('Failed to search doctors: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to search doctors: $e');
    }
  }
}
