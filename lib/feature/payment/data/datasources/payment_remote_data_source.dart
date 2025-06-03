import 'package:dio/dio.dart';
import '../models/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<void> processPayment(PaymentModel payment);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio dio;

  PaymentRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> processPayment(PaymentModel payment) async {
    try {
      final response = await dio.post(
        '/api/Payment',
        data: payment.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to process payment: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            'Failed to process payment: ${e.response?.data['message'] ?? e.message}');
      }
      throw Exception('Failed to process payment: ${e.message}');
    } catch (e) {
      throw Exception('Failed to process payment: $e');
    }
  }
}
