class AppointmentModel {
  final int id;
  final String doctor;
  final String clinic;
  final String governorate;
  final String city;
  final String street;
  final String day;
  final String appointmentStart;
  final String appointmentEnd;
  final String status;

  AppointmentModel({
    required this.id,
    required this.doctor,
    required this.clinic,
    required this.governorate,
    required this.city,
    required this.street,
    required this.day,
    required this.appointmentStart,
    required this.appointmentEnd,
    required this.status,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      doctor: json['doctor'],
      clinic: json['clinic'],
      governorate: json['governorate'],
      city: json['city'],
      street: json['street'],
      day: json['day'],
      appointmentStart: json['appointmentStart'],
      appointmentEnd: json['appointmentEnd'],
      status: json['status'],
    );
  }
}
