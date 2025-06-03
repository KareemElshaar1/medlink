import '../entities/payment.dart';

abstract class PaymentRepository {
  Future<void> processPayment(Payment payment);
}
