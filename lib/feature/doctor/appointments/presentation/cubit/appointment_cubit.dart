import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../../domain/entities/appointment.dart';

// States
abstract class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentLoaded extends AppointmentState {
  final List<Appointment> appointments;

  AppointmentLoaded(this.appointments);
}

class AppointmentError extends AppointmentState {
  final String message;

  AppointmentError(this.message);
}

// Cubit
class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentRepository _repository;

  AppointmentCubit(this._repository) : super(AppointmentInitial());

  Future<void> getAppointments() async {
    try {
      emit(AppointmentLoading());
      final appointments = await _repository.getAppointments();
      emit(AppointmentLoaded(appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }
}
