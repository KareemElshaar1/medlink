import 'package:equatable/equatable.dart';

class GovernateModel extends Equatable {
  final int id;
  final String name;

  const GovernateModel({
    required this.id,
    required this.name,
  });

  factory GovernateModel.fromJson(Map<String, dynamic> json) {
    return GovernateModel(
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
