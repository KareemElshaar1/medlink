import '../../data/models/appointment_model.dart';

abstract class PaymentRepository {
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
