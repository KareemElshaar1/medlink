import 'product.dart';

class ProductModel extends Product {
  ProductModel({
    required String id,
    required String name,
    required String image,
    required num price,
  }) : super(id: id, name: name, image: image, price: price);

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      price: json['price'] as num,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'price': price,
      };
}
