class AppointmentModel {
  final String patient;
  final String clinic;
  final String day;
  final String appointmentStart;
  final String appointmentEnd;

  AppointmentModel({
    required this.patient,
    required this.clinic,
    required this.day,
    required this.appointmentStart,
    required this.appointmentEnd,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      patient: json['patient'] as String,
      clinic: json['clinic'] as String,
      day: json['day'] as String,
      appointmentStart: json['appointmentStart'] as String,
      appointmentEnd: json['appointmentEnd'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient': patient,
      'clinic': clinic,
      'day': day,
      'appointmentStart': appointmentStart,
      'appointmentEnd': appointmentEnd,
    };
  }
}
