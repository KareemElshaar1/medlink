import 'package:equatable/equatable.dart';

class ClinicModel extends Equatable {
  final int? id;
  final String name;
  final String phone;
  final double price;
  final String location;
  final String street;
  final String postalCode;
  final int specialityId;
  final int governateId;
  final int cityId;

  const ClinicModel({
    this.id,
    required this.name,
    required this.phone,
    required this.price,
    required this.location,
    required this.street,
    required this.postalCode,
    required this.specialityId,
    required this.governateId,
    required this.cityId,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      location: json['location'] as String? ?? '',
      street: json['street'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
      specialityId: json['specialityId'] as int? ?? 0,
      governateId: json['governateId'] as int? ?? 0,
      cityId: json['cityId'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'phone': phone,
      'price': price,
      'location': location,
      'street': street,
      'postalCode': postalCode,
      'specialityId': specialityId,
      'governateId': governateId,
      'cityId': cityId,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        price,
        location,
        street,
        postalCode,
        specialityId,
        governateId,
        cityId
      ];
}
