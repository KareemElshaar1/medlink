import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/doctor_schedule.dart';
import '../../domain/use_cases/get_doctor_schedule_usecase.dart';

// States
abstract class DoctorScheduleState extends Equatable {
  const DoctorScheduleState();

  @override
  List<Object> get props => [];
}

class DoctorScheduleInitial extends DoctorScheduleState {}

class DoctorScheduleLoading extends DoctorScheduleState {}

class DoctorScheduleLoaded extends DoctorScheduleState {
  final List<DoctorSchedule> schedules;

  const DoctorScheduleLoaded(this.schedules);

  @override
  List<Object> get props => [schedules];
}

class DoctorScheduleError extends DoctorScheduleState {
  final String message;

  const DoctorScheduleError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class DoctorScheduleCubit extends Cubit<DoctorScheduleState> {
  final GetDoctorScheduleUseCase getDoctorScheduleUseCase;

  DoctorScheduleCubit({required this.getDoctorScheduleUseCase})
      : super(DoctorScheduleInitial());

  Future<void> getDoctorSchedule(int doctorId) async {
    emit(DoctorScheduleLoading());
    try {
      final schedules = await getDoctorScheduleUseCase(doctorId);
      emit(DoctorScheduleLoaded(schedules));
    } catch (e) {
      emit(DoctorScheduleError(e.toString()));
    }
  }
}
