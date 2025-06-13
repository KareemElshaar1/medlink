class DoctorScheduleModel {
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

  DoctorScheduleModel({
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

  factory DoctorScheduleModel.fromJson(Map<String, dynamic> json) {
    return DoctorScheduleModel(
      docId: json['docId'] as int,
      clinicId: json['clinicId'] as int,
      doctor: json['doctor'] as String,
      clinic: json['clinic'] as String,
      street: json['street'] as String,
      governate: json['governate'] as String,
      city: json['city'] as String,
      price: (json['price'] as num).toDouble(),
      phone: json['phone'] as String,
      day: json['day'] as String,
      appointmentStart: json['appointmentStart'] as String,
      appointmentEnd: json['appointmentEnd'] as String,
    );
  }
}
