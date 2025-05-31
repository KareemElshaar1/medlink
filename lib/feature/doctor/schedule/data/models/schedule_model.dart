class ScheduleModel {
  final int id;
  final String day;
  final String appointmentStart;
  final String appointmentEnd;
  final String clinic;
  final int clinicId;

  ScheduleModel({
    required this.id,
    required this.day,
    required this.appointmentStart,
    required this.appointmentEnd,
    required this.clinic,
    required this.clinicId,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'],
      day: json['day'],
      appointmentStart: json['appointmentStart'],
      appointmentEnd: json['appointmentEnd'],
      clinic: json['clinic'],
      clinicId: json['id'],
    );
  }
}
