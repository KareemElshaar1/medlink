import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_data_source.dart';
import '../models/payment_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> processPayment(Payment payment) async {
    final paymentModel = PaymentModel(
      appointmentId: payment.appointmentId,
      cardNumber: payment.cardNumber,
      cardHolderName: payment.cardHolderName,
      expirationMonth: payment.expirationMonth,
      expirationYear: payment.expirationYear,
      cvv: payment.cvv,
    );

    await remoteDataSource.processPayment(paymentModel);
  }
}
