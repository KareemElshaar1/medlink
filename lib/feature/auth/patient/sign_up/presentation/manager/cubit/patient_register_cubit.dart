import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:medlink/feature/auth/patient/sign_up/presentation/manager/cubit/patient_register_state.dart';
import 'package:medlink/core/helper/shared_pref_helper.dart';

import '../../../domain/entities/patient_entities.dart';
import '../../../domain/use_cases/patient_usecase.dart';

class PatientRegistrationCubit extends Cubit<PatientRegistrationState> {
  final RegisterpatientUseCase registerPatientUseCase;
  static const String _patientTokenKey = 'patient_auth_token';

  PatientRegistrationCubit(this.registerPatientUseCase)
      : super(PatientRegistrationInitial());

  Future<void> registerPatient(Patient patient) async {
    emit(PatientRegistrationLoading());
    try {
      await registerPatientUseCase.execute(patient);
      emit(PatientRegistrationSuccess());
    } catch (e) {
      String errorMessage = 'Registration failed';
      if (e is DioException) {
        if (e.response?.data is Map<String, dynamic>) {
          final errorData = e.response?.data as Map<String, dynamic>;
          if (errorData.containsKey('detail')) {
            errorMessage = errorData['detail'].toString();
          }
        }
      }
      emit(PatientRegistrationError(errorMessage));
    }
  }

  Future<void> sendVerificationToken() async {
    try {
      emit(PatientRegistrationLoading());
      // TODO: Implement the API call to send verification token
      // This should be implemented based on your backend API
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      // Save the token to secure storage
      // Replace this with your actual token from the API response
      const String token = 'your_verification_token_here';
      await SharedPrefHelper.setSecuredString(_patientTokenKey, token);

      emit(PatientRegistrationSuccess());
    } catch (e) {
      emit(PatientRegistrationError(e.toString()));
      rethrow;
    }
  }
}
