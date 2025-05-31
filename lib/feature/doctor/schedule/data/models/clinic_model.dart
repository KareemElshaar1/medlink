class ClinicModel {
  final int id;
  final String name;
  final String phone;
  final double price;
  final String location;

  ClinicModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.price,
    required this.location,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      price: json['price'].toDouble(),
      location: json['location'],
    );
  }
}
