import 'package:dio/dio.dart';
import '../../domain/models/clinic_model.dart';
import '../../domain/models/governate_model.dart';
import '../../domain/models/city_model.dart';
import '../../domain/models/speciality_model.dart';

abstract class ClinicRemoteDataSource {
  Future<bool> addClinic(ClinicModel clinic);
  Future<List<GovernateModel>> getGovernates();
  Future<List<CityModel>> getCities(int governateId);
  Future<List<SpecialityModel>> getSpecialities();
  Future<List<ClinicModel>> getClinics();
}

class ClinicRemoteDataSourceImpl implements ClinicRemoteDataSource {
  final Dio dio;

  ClinicRemoteDataSourceImpl(this.dio);

  @override
  Future<bool> addClinic(ClinicModel clinic) async {
    try {
      final response = await dio.post(
        '/api/Doctors/AddClinic',
        data: clinic.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.statusCode == 204) {
          return true;
        }
        return response.data['isSuccess'] == true;
      }

      return false;
    } catch (e) {
      throw Exception('Failed to add clinic: $e');
    }
  }

  @override
  Future<List<GovernateModel>> getGovernates() async {
    try {
      final response = await dio.get('/api/Doctors/GetGovernates');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => GovernateModel.fromJson(json)).toList();
      }

      throw Exception('Failed to get governates');
    } catch (e) {
      throw Exception('Failed to get governates: $e');
    }
  }

  @override
  Future<List<CityModel>> getCities(int governateId) async {
    try {
      final response =
          await dio.get('/api/Doctors/GetAreas?govId=$governateId');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => CityModel.fromJson(json)).toList();
      }

      throw Exception('Failed to get cities');
    } catch (e) {
      throw Exception('Failed to get cities: $e');
    }
  }

  @override
  Future<List<SpecialityModel>> getSpecialities() async {
    try {
      final response = await dio.get('/api/Specialities');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            response.data as Map<String, dynamic>;
        if (responseData['isSuccess'] == true) {
          final List<dynamic> data = responseData['data'] as List<dynamic>;
          return data.map((json) => SpecialityModel.fromJson(json)).toList();
        }
      }

      throw Exception('Failed to get specialities');
    } catch (e) {
      throw Exception('Failed to get specialities: $e');
    }
  }

  @override
  Future<List<ClinicModel>> getClinics() async {
    try {
      final response = await dio.get('/api/Doctors/Clinics');

      if (response.statusCode != 200) {
        throw Exception('Failed to get clinics');
      }

      final List<dynamic> data = response.data;
      return data.map((json) => ClinicModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get clinics: $e');
    }
  }
}
