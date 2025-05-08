// lib/data/datasources/specialities_remote_data_source_impl.dart
import 'package:dio/dio.dart';
import 'package:medlink/feature/specilaity/domain/entities/speciality_entity.dart';
 import 'specialities_remote_data_source.dart';

class SpecialitiesRemoteDataSourceImpl implements SpecialitiesRemoteDataSource {
  final Dio dio;

  SpecialitiesRemoteDataSourceImpl(this.dio);

  @override
  Future<List<Speciality>> getSpecialities() async {
    try {
      final response =
          await dio.get('http://medlink.runasp.net/api/Specialities');

      if (response.statusCode == 200 &&
          response.data['isSuccess'] == true &&
          response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((item) => Speciality.fromJson(item))
            .toList();
      }

      throw Exception('Failed to load specialities');
    } catch (e) {
      throw Exception('Failed to load specialities: $e');
    }
  }
}
