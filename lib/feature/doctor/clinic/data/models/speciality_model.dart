import 'package:equatable/equatable.dart';

class SpecialityModel extends Equatable {
  final int id;
  final String name;

  const SpecialityModel({
    required this.id,
    required this.name,
  });

  factory SpecialityModel.fromJson(Map<String, dynamic> json) {
    return SpecialityModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  List<Object?> get props => [id, name];
}
