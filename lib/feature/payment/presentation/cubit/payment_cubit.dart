import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/process_payment_usecase.dart';
import '../../domain/use_cases/get_appointments_usecase.dart';
import '../../domain/use_cases/cancel_appointment_usecase.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final ProcessPaymentUseCase processPaymentUseCase;
  final GetAppointmentsUseCase getAppointmentsUseCase;
  final CancelAppointmentUseCase cancelAppointmentUseCase;

  PaymentCubit({
    required this.processPaymentUseCase,
    required this.getAppointmentsUseCase,
    required this.cancelAppointmentUseCase,
  }) : super(PaymentInitial());

  Future<void> processPayment({
    required int appointmentId,
    required String cardNumber,
    required String cardHolderName,
    required String expirationMonth,
    required String expirationYear,
    required String cvv,
  }) async {
    emit(PaymentLoading());
    try {
      final result = await processPaymentUseCase(
        appointmentId: appointmentId,
        cardNumber: cardNumber,
        cardHolderName: cardHolderName,
        expirationMonth: expirationMonth,
        expirationYear: expirationYear,
        cvv: cvv,
      );
      emit(PaymentLoaded(result));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }

  Future<void> getAppointments() async {
    emit(PaymentLoading());
    try {
      final appointments = await getAppointmentsUseCase();
      emit(AppointmentsLoaded(appointments));
    } catch (e) {
      if (e.toString().contains('404')) {
        // If no appointments found, emit empty list instead of error
        emit(AppointmentsLoaded([]));
      } else {
        emit(PaymentError(e.toString()));
      }
    }
  }

  Future<void> cancelAppointment(int appointmentId) async {
    try {
      await cancelAppointmentUseCase(appointmentId);
      // Refresh appointments after cancellation
      await getAppointments();
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }
}
