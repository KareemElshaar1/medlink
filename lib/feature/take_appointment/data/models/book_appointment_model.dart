class BookAppointmentModel {
  final int doctorId;
  final int clinicId;
  final String day;
  final String appointmentStart;
  final String appointmentEnd;

  BookAppointmentModel({
    required this.doctorId,
    required this.clinicId,
    required this.day,
    required this.appointmentStart,
    required this.appointmentEnd,
  });

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'clinicId': clinicId,
      'day': day,
      'appointmentStart': appointmentStart,
      'appointmentEnd': appointmentEnd,
    };
  }
}
