import 'package:equatable/equatable.dart';

import '../../data/models/city_model.dart';
import '../../data/models/clinic_model.dart';
import '../../data/models/governate_model.dart';
import '../../data/models/speciality_model.dart';

abstract class ClinicEvent extends Equatable {
  const ClinicEvent();

  @override
  List<Object?> get props => [];
}

class AddClinic extends ClinicEvent {
  final ClinicModel clinic;

  const AddClinic(this.clinic);

  @override
  List<Object?> get props => [clinic];
}

class DeleteClinic extends ClinicEvent {
  final int id;

  const DeleteClinic(this.id);

  @override
  List<Object?> get props => [id];
}

class GetGovernatesEvent extends ClinicEvent {}

class GetCitiesEvent extends ClinicEvent {
  final int governateId;

  const GetCitiesEvent(this.governateId);

  @override
  List<Object?> get props => [governateId];
}

class GetSpecialitiesEvent extends ClinicEvent {}

class GetClinicsEvent extends ClinicEvent {}

// States
abstract class ClinicState extends Equatable {
  const ClinicState();

  @override
  List<Object?> get props => [];
}

class ClinicInitial extends ClinicState {}

class ClinicLoading extends ClinicState {}

class ClinicSuccess extends ClinicState {
  final ClinicModel clinic;

  const ClinicSuccess(this.clinic);

  @override
  List<Object?> get props => [clinic];
}

class ClinicError extends ClinicState {
  final String message;

  const ClinicError(this.message);

  @override
  List<Object?> get props => [message];
}

class GovernatesLoaded extends ClinicState {
  final List<GovernateModel> governates;

  const GovernatesLoaded(this.governates);

  @override
  List<Object?> get props => [governates];
}

class CitiesLoaded extends ClinicState {
  final List<CityModel> cities;

  const CitiesLoaded(this.cities);

  @override
  List<Object?> get props => [cities];
}

class SpecialitiesLoaded extends ClinicState {
  final List<SpecialityModel> specialities;

  const SpecialitiesLoaded(this.specialities);

  @override
  List<Object?> get props => [specialities];
}

class ClinicsLoaded extends ClinicState {
  final List<ClinicModel> clinics;

  const ClinicsLoaded(this.clinics);

  @override
  List<Object?> get props => [clinics];
}
