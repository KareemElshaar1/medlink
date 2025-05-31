import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/clinic_model.dart';
import '../../data/models/schedule_model.dart';
import '../../domain/use_cases/get_clinics_usecase.dart';
import '../../domain/use_cases/create_schedule_usecase.dart';
import '../../domain/use_cases/get_schedule_usecase.dart';
import '../../domain/use_cases/delete_schedule_usecase.dart';
import '../../domain/use_cases/edit_schedule_usecase.dart';

part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final GetScheduleClinicsUseCase getClinicsUseCase;
  final CreateScheduleUseCase createScheduleUseCase;
  final GetScheduleUseCase getScheduleUseCase;
  final DeleteScheduleUseCase deleteScheduleUseCase;
  final EditScheduleUseCase editScheduleUseCase;

  ScheduleCubit({
    required this.getClinicsUseCase,
    required this.createScheduleUseCase,
    required this.getScheduleUseCase,
    required this.deleteScheduleUseCase,
    required this.editScheduleUseCase,
  }) : super(ScheduleInitial());

  Future<void> getClinics() async {
    emit(ScheduleLoading());
    try {
      final clinics = await getClinicsUseCase();
      emit(ClinicsLoaded(clinics));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> createSchedule({
    required String day,
    required String appointmentStart,
    required String appointmentEnd,
    required int clinicId,
  }) async {
    emit(ScheduleLoading());
    try {
      await createScheduleUseCase(
        day: day,
        appointmentStart: appointmentStart,
        appointmentEnd: appointmentEnd,
        clinicId: clinicId,
      );
      emit(ScheduleCreated());
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> getSchedule() async {
    emit(ScheduleLoading());
    try {
      final schedules = await getScheduleUseCase();
      emit(SchedulesLoaded(schedules));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> deleteSchedule(int id) async {
    emit(ScheduleLoading());
    try {
      await deleteScheduleUseCase(id);
      emit(ScheduleDeleted());
      await getSchedule(); // Refresh the list after deletion
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> editSchedule({
    required int id,
    required String day,
    required String appointmentStart,
    required String appointmentEnd,
    required int clinicId,
  }) async {
    emit(ScheduleLoading());
    try {
      await editScheduleUseCase(
        id: id,
        day: day,
        appointmentStart: appointmentStart,
        appointmentEnd: appointmentEnd,
        clinicId: clinicId,
      );
      emit(ScheduleEdited());
      await getSchedule(); // Refresh the list after editing
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }
}
