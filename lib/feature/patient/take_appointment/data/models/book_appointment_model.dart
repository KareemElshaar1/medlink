class BookAppointmentModel {
  final int? id;
  final int doctorId;
  final int clinicId;
  final String day;
  final String appointmentStart;
  final String appointmentEnd;

  BookAppointmentModel({
    this.id,
    required this.doctorId,
    required this.clinicId,
    required this.day,
    required this.appointmentStart,
    required this.appointmentEnd,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'doctorId': doctorId,
      'clinicId': clinicId,
      'day': day,
      'appointmentStart': appointmentStart,
      'appointmentEnd': appointmentEnd,
    };
  }
}
