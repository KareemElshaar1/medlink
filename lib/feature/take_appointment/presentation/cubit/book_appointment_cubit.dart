import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/use_cases/book_appointment_usecase.dart';
import '../../data/models/book_appointment_model.dart';

// States
abstract class BookAppointmentState extends Equatable {
  const BookAppointmentState();

  @override
  List<Object> get props => [];
}

class BookAppointmentInitial extends BookAppointmentState {}

class BookAppointmentLoading extends BookAppointmentState {}

class BookAppointmentSuccess extends BookAppointmentState {}

class BookAppointmentError extends BookAppointmentState {
  final String message;

  const BookAppointmentError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class BookAppointmentCubit extends Cubit<BookAppointmentState> {
  final BookAppointmentUseCase bookAppointmentUseCase;

  BookAppointmentCubit({required this.bookAppointmentUseCase})
      : super(BookAppointmentInitial());

  Future<void> bookAppointment(BookAppointmentModel appointment) async {
    emit(BookAppointmentLoading());
    try {
      await bookAppointmentUseCase(appointment);
      emit(BookAppointmentSuccess());
    } catch (e) {
      emit(BookAppointmentError(e.toString()));
    }
  }
}
