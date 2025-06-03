class BookAppointment {
  final int? id;
  final int doctorId;
  final int clinicId;
  final String day;
  final String appointmentStart;
  final String appointmentEnd;

  BookAppointment({
    this.id,
    required this.doctorId,
    required this.clinicId,
    required this.day,
    required this.appointmentStart,
    required this.appointmentEnd,
  });
}
