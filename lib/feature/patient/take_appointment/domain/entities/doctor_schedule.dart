class DoctorSchedule {
  final int docId;
  final int clinicId;
  final String doctor;
  final String clinic;
  final String street;
  final String governate;
  final String city;
  final double price;
  final String phone;
  final String day;
  final String appointmentStart;
  final String appointmentEnd;

  DoctorSchedule({
    required this.docId,
    required this.clinicId,
    required this.doctor,
    required this.clinic,
    required this.street,
    required this.governate,
    required this.city,
    required this.price,
    required this.phone,
    required this.day,
    required this.appointmentStart,
    required this.appointmentEnd,
  });
}
