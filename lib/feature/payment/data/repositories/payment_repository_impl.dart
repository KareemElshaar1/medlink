import '../datasources/payment_remote_data_source.dart';
import '../../domain/repositories/payment_repository.dart';
import '../models/appointment_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> processPayment({
    required int appointmentId,
    required String cardNumber,
    required String cardHolderName,
    required String expirationMonth,
    required String expirationYear,
    required String cvv,
  }) async {
    return await remoteDataSource.processPayment(
      appointmentId: appointmentId,
      cardNumber: cardNumber,
      cardHolderName: cardHolderName,
      expirationMonth: expirationMonth,
      expirationYear: expirationYear,
      cvv: cvv,
    );
  }

  @override
  Future<List<AppointmentModel>> getAppointments() async {
    return await remoteDataSource.getAppointments();
  }
}
