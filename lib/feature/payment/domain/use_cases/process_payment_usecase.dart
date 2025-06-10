import '../repositories/payment_repository.dart';

class ProcessPaymentUseCase {
  final PaymentRepository repository;

  ProcessPaymentUseCase({required this.repository});

  Future<Map<String, dynamic>> call({
    required int appointmentId,
    required String cardNumber,
    required String cardHolderName,
    required String expirationMonth,
    required String expirationYear,
    required String cvv,
  }) async {
    return await repository.processPayment(
      appointmentId: appointmentId,
      cardNumber: cardNumber,
      cardHolderName: cardHolderName,
      expirationMonth: expirationMonth,
      expirationYear: expirationYear,
      cvv: cvv,
    );
  }
}
