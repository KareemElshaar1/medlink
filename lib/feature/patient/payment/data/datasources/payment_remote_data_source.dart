import 'package:dio/dio.dart';
import '../models/appointment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<Map<String, dynamic>> processPayment({
    required int appointmentId,
    required String cardNumber,
    required String cardHolderName,
    required String expirationMonth,
    required String expirationYear,
    required String cvv,
  });
  Future<List<AppointmentModel>> getAppointments();
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio dio;

  PaymentRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> processPayment({
    required int appointmentId,
    required String cardNumber,
    required String cardHolderName,
    required String expirationMonth,
    required String expirationYear,
    required String cvv,
  }) async {
    try {
      final response = await dio.post(
        '/api/Payment',
        data: {
          'appointmentId': appointmentId,
          'cardNumber': cardNumber,
          'cardHolderName': cardHolderName,
          'expirationMonth': expirationMonth,
          'expirationYear': expirationYear,
          'cvv': cvv,
        },
      );

      // Handle both String and Map responses
      if (response.data is String) {
        return {
          'status': 'success',
          'message': response.data,
        };
      } else if (response.data is Map<String, dynamic>) {
        return response.data;
      } else {
        throw Exception('Unexpected response format from server');
      }
    } catch (e) {
      throw Exception('Failed to process payment: $e');
    }
  }

  @override
  Future<List<AppointmentModel>> getAppointments() async {
    try {
      final response = await dio.get('/api/Patient/GetAppointments');
      return (response.data as List)
          .map((json) => AppointmentModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get appointments: $e');
    }
  }
}
