import 'package:equatable/equatable.dart';

class PatientDataModel extends Equatable {
  final double age;
  final double? weight;
  final String drug;
  final String route;
  final String gender;
  final String admissionType;
  final String? diagnosis;

  const PatientDataModel({
    required this.age,
    this.weight,
    required this.drug,
    required this.route,
    required this.gender,
    required this.admissionType,
    this.diagnosis,
  });

  factory PatientDataModel.fromJson(Map<String, dynamic> json) {
    return PatientDataModel(
      age: (json['age'] as num).toDouble(),
      weight:
          json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      drug: json['drug'] as String,
      route: json['route'] as String,
      gender: json['gender'] as String,
      admissionType: json['admission_type'] as String,
      diagnosis: json['diagnosis'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'weight': weight,
      'drug': drug,
      'route': route,
      'gender': gender,
      'admission_type': admissionType,
      'diagnosis': diagnosis,
    };
  }

  @override
  List<Object?> get props =>
      [age, weight, drug, route, gender, admissionType, diagnosis];
}
