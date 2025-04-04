abstract class PatientRegistrationState {}

class PatientRegistrationInitial extends PatientRegistrationState {}

class PatientRegistrationLoading extends PatientRegistrationState {}

class PatientRegistrationSuccess extends PatientRegistrationState {}

class PatientRegistrationError extends PatientRegistrationState {
  final String message;

  PatientRegistrationError(this.message);
}