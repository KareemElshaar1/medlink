import 'package:medlink/feature/pharmacy/data/product_model.dart';

class ProductsResponseModel {
  final int code;
  final bool error;
  final List<ProductModel> products;

  ProductsResponseModel({
    required this.code,
    required this.error,
    required this.products,
  });

  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductsResponseModel(
      code: json['code'] as int,
      error: json['error'] as bool,
      products: (json['products'] as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
