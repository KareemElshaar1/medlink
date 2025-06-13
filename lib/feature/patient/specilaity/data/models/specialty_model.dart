class SpecialtyModel {
  final int id;
  final String name;
  final String icon;
  final String description;

  SpecialtyModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyModel(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
    };
  }
}
