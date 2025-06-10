import 'package:flutter/foundation.dart';
import '../../domain/use_cases/process_payment_usecase.dart';
import '../../domain/use_cases/get_appointments_usecase.dart';
import 'payment_state.dart';

class PaymentCubit extends ChangeNotifier {
  final ProcessPaymentUseCase processPaymentUseCase;
  final GetAppointmentsUseCase getAppointmentsUseCase;
  PaymentState _state = PaymentInitial();

  PaymentCubit({
    required this.processPaymentUseCase,
    required this.getAppointmentsUseCase,
  });

  PaymentState get state => _state;

  Future<void> processPayment({
    required int appointmentId,
    required String cardNumber,
    required String cardHolderName,
    required String expirationMonth,
    required String expirationYear,
    required String cvv,
  }) async {
    _state = PaymentLoading();
    notifyListeners();
    try {
      final result = await processPaymentUseCase(
        appointmentId: appointmentId,
        cardNumber: cardNumber,
        cardHolderName: cardHolderName,
        expirationMonth: expirationMonth,
        expirationYear: expirationYear,
        cvv: cvv,
      );
      _state = PaymentLoaded(result);
      notifyListeners();
    } catch (e) {
      _state = PaymentError(e.toString());
      notifyListeners();
    }
  }

  Future<void> getAppointments() async {
    _state = PaymentLoading();
    notifyListeners();
    try {
      final appointments = await getAppointmentsUseCase();
      _state = AppointmentsLoaded(appointments);
      notifyListeners();
    } catch (e) {
      _state = PaymentError(e.toString());
      notifyListeners();
    }
  }
}
