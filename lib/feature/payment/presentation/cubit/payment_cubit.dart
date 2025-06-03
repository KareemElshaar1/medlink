import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/payment.dart';
import '../../domain/use_cases/process_payment_usecase.dart';

// States
abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {}

class PaymentError extends PaymentState {
  final String message;

  PaymentError(this.message);
}

// Cubit
class PaymentCubit extends Cubit<PaymentState> {
  final ProcessPaymentUseCase processPaymentUseCase;

  PaymentCubit({required this.processPaymentUseCase}) : super(PaymentInitial());

  Future<void> processPayment(Payment payment) async {
    emit(PaymentLoading());
    try {
      await processPaymentUseCase(payment);
      emit(PaymentSuccess());
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }
}
