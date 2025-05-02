import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/clinic_model.dart';
import '../../domain/use_cases/add_clinic_usecase.dart';
import '../../domain/use_cases/get_cities_usecase.dart';
import '../../domain/use_cases/get_clinics_usecase.dart';
import '../../domain/use_cases/get_governates_usecase.dart';
import '../../domain/use_cases/get_specialities_usecase.dart';
import 'clinic_state.dart';

// Cubit

class ClinicCubit extends Cubit<ClinicState> {
  final AddClinicUseCase addClinicUseCase;
  final GetGovernatesUseCase getGovernatesUseCase;
  final GetCitiesUseCase getCitiesUseCase;
  final GetSpecialitieUseCase getSpecialitiesUseCase;
  final GetClinicsUseCase getClinicsUseCase;

  ClinicCubit({
    required this.addClinicUseCase,
    required this.getGovernatesUseCase,
    required this.getCitiesUseCase,
    required this.getSpecialitiesUseCase,
    required this.getClinicsUseCase,
  }) : super(ClinicInitial());

  Future<void> addClinic(ClinicModel clinic) async {
    try {
      emit(ClinicLoading());
      final success = await addClinicUseCase(clinic);
      if (success) {
        emit(ClinicSuccess(clinic));
        // Refresh the clinics list after adding a new clinic
        getClinics();
      } else {
        emit(const ClinicError('Failed to add clinic'));
      }
    } catch (e) {
      emit(ClinicError(e.toString()));
    }
  }

  Future<void> getGovernates() async {
    emit(ClinicLoading());
    try {
      final governates = await getGovernatesUseCase();
      emit(GovernatesLoaded(governates));
    } catch (e) {
      emit(ClinicError(e.toString()));
    }
  }

  Future<void> getCities(int governateId) async {
    emit(ClinicLoading());
    try {
      final cities = await getCitiesUseCase(governateId);
      emit(CitiesLoaded(cities));
    } catch (e) {
      emit(ClinicError(e.toString()));
    }
  }

  Future<void> getSpecialities() async {
    emit(ClinicLoading());
    try {
      final specialities = await getSpecialitiesUseCase();
      emit(SpecialitiesLoaded(specialities));
    } catch (e) {
      emit(ClinicError(e.toString()));
    }
  }

  Future<void> getClinics() async {
    emit(ClinicLoading());
    try {
      final clinics = await getClinicsUseCase();
      emit(ClinicsLoaded(clinics));
    } catch (e) {
      emit(ClinicError(e.toString()));
    }
  }
}
