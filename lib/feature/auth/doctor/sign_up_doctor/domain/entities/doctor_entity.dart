// lib/domain/entities/doctor.dart
class Doctor {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final int specialityId;

  Doctor({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.specialityId,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'specialityId': specialityId,
    };
  }
}