import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/doctor_profile_model.dart';
import '../../data/repositories/doctor_profile_repository.dart';

// Events
abstract class DoctorProfileEvent extends Equatable {
  const DoctorProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadDoctorProfile extends DoctorProfileEvent {}

// States
abstract class DoctorProfileState extends Equatable {
  const DoctorProfileState();

  @override
  List<Object> get props => [];
}

class DoctorProfileInitial extends DoctorProfileState {}

class DoctorProfileLoading extends DoctorProfileState {}

class DoctorProfileLoaded extends DoctorProfileState {
  final DoctorProfileModel profile;

  const DoctorProfileLoaded(this.profile);

  @override
  List<Object> get props => [profile];
}

class DoctorProfileError extends DoctorProfileState {
  final String message;

  const DoctorProfileError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class DoctorProfileCubit extends Cubit<DoctorProfileState> {
  final DoctorProfileRepository _repository;

  DoctorProfileCubit(this._repository) : super(DoctorProfileInitial());

  Future<void> loadProfile() async {
    emit(DoctorProfileLoading());
    try {
      final profile = await _repository.getDoctorProfile();
      emit(DoctorProfileLoaded(profile));
    } catch (e) {
      emit(DoctorProfileError(e.toString()));
    }
  }
}