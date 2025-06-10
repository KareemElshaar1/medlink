import '../../data/models/appointment_model.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final dynamic paymentData;

  PaymentLoaded(this.paymentData);
}

class PaymentError extends PaymentState {
  final String message;

  PaymentError(this.message);
}

class AppointmentsLoaded extends PaymentState {
  final List<AppointmentModel> appointments;

  AppointmentsLoaded(this.appointments);
}
