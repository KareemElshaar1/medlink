// lib/presentation/cubits/doctor_registration_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/use_cases/doctor_register_usecase.dart';

// States
abstract class DoctorRegistrationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DoctorRegistrationInitial extends DoctorRegistrationState {}

class DoctorRegistrationLoading extends DoctorRegistrationState {}

class DoctorRegistrationSuccess extends DoctorRegistrationState {}

class DoctorRegistrationError extends DoctorRegistrationState {
  final String message;

  DoctorRegistrationError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class DoctorRegistrationCubit extends Cubit<DoctorRegistrationState> {
  final RegisterDoctorUseCase registerDoctorUseCase;

  DoctorRegistrationCubit(this.registerDoctorUseCase)
      : super(DoctorRegistrationInitial());

  Future<void> registerDoctor({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required int specialityId,
  }) async {
    emit(DoctorRegistrationLoading());
    try {
      final success = await registerDoctorUseCase.registerDoctor(
        firstName,
        lastName,
        email,
        phone,
        password,
        confirmPassword,
        specialityId,
      );

      if (success) {
        emit(DoctorRegistrationSuccess());
      } else {
        emit(DoctorRegistrationError('Registration failed'));
      }
    } catch (e) {
      emit(DoctorRegistrationError(e.toString()));
    }
  }
}
