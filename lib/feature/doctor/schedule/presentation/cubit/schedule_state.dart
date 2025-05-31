part of 'schedule_cubit.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleError extends ScheduleState {
  final String message;

  const ScheduleError(this.message);

  @override
  List<Object> get props => [message];
}

class ClinicsLoaded extends ScheduleState {
  final List<ClinicModel> clinics;

  const ClinicsLoaded(this.clinics);

  @override
  List<Object> get props => [clinics];
}

class ScheduleCreated extends ScheduleState {}

class ScheduleDeleted extends ScheduleState {}

class ScheduleEdited extends ScheduleState {}

class SchedulesLoaded extends ScheduleState {
  final List<ScheduleModel> schedules;

  const SchedulesLoaded(this.schedules);

  @override
  List<Object> get props => [schedules];
}
