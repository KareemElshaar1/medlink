import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class ProcessPaymentUseCase {
  final PaymentRepository repository;

  ProcessPaymentUseCase({required this.repository});

  Future<void> call(Payment payment) async {
    await repository.processPayment(payment);
  }
}
