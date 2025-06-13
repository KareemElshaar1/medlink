import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.category,
    required super.manufacturer,
    required super.stockQuantity,
    required super.isAvailable,
    required super.attributes,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      imageUrl: json['image']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      manufacturer: json['manufacturer']?.toString() ?? '',
      stockQuantity: int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      isAvailable: json['available']?.toString().toLowerCase() == 'true',
      attributes: (json['attributes'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value.toString()),
          ) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price.toString(),
      'image': imageUrl,
      'category': category,
      'manufacturer': manufacturer,
      'stock': stockQuantity.toString(),
      'available': isAvailable.toString(),
      'attributes': attributes,
    };
  }
}
