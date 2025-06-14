// lib/presentation/cubits/doctor_registration_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:medlink/core/helper/shared_pref_helper.dart';
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
  static const String _doctorTokenKey = 'doctor_auth_token';

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
    } on DioException catch (e) {
      String errorMessage = 'Registration failed';
      if (e.response?.data is Map<String, dynamic>) {
        final errorData = e.response?.data as Map<String, dynamic>;
        if (errorData.containsKey('detail')) {
          errorMessage = errorData['detail'].toString();
        }
      }
      emit(DoctorRegistrationError(errorMessage));
    } catch (e) {
      emit(DoctorRegistrationError('An unexpected error occurred'));
    }
  }

  Future<void> sendVerificationToken() async {
    try {
      emit(DoctorRegistrationLoading());
      // TODO: Implement the API call to send verification token
      // This should be implemented based on your backend API
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      // Save the token to secure storage
      // Replace this with your actual token from the API response
      const String token = 'your_verification_token_here';
      await SharedPrefHelper.setSecuredString(_doctorTokenKey, token);

      emit(DoctorRegistrationSuccess());
    } catch (e) {
      emit(DoctorRegistrationError(e.toString()));
      rethrow;
    }
  }
}
