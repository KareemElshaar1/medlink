import 'package:equatable/equatable.dart';

class Clinic extends Equatable {
  final String name;
  final String phone;
  final double consultationPrice;
  final Address address;
  final String speciality;

  const Clinic({
    required this.name,
    required this.phone,
    required this.consultationPrice,
    required this.address,
    required this.speciality,
  });

  @override
  List<Object?> get props =>
      [name, phone, consultationPrice, address, speciality];
}

class Address extends Equatable {
  final String street;
  final String postalCode;
  final String governate;
  final String city;

  const Address({
    required this.street,
    required this.postalCode,
    required this.governate,
    required this.city,
  });

  @override
  List<Object?> get props => [street, postalCode, governate, city];
}
