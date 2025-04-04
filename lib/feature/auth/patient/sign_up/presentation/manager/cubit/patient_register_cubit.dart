import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medlink/feature/auth/patient/sign_up/presentation/manager/cubit/patient_register_state.dart';

import '../../../domain/entities/patient_entities.dart';
import '../../../domain/use_cases/patient_usecase.dart';

class PatientRegistrationCubit extends Cubit<PatientRegistrationState> {
  final RegisterpatientUseCase registerPatientUseCase;

  PatientRegistrationCubit(this.registerPatientUseCase) : super(PatientRegistrationInitial());

  Future<void> registerPatient(Patient patient) async {
    emit(PatientRegistrationLoading());
    try {
      await registerPatientUseCase.execute(patient);
      emit(PatientRegistrationSuccess());
    } catch (e) {
      emit(PatientRegistrationError(e.toString()));
    }
  }
}