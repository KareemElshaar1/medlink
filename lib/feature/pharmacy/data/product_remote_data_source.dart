import 'package:dio/dio.dart';
import 'package:medlink/feature/pharmacy/data/product_model.dart';
import 'package:medlink/feature/pharmacy/data/products_response_model.dart';
 
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> searchProducts(String name);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;
  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductModel>> searchProducts(String name) async {
    final resp = await dio.get(
      'http://moelshafey.xyz/API/MD/search.php',
      queryParameters: {'name': name},
    );
    final model = ProductsResponseModel.fromJson(resp.data as Map<String, dynamic>);
    if (model.code == 200 && model.error == false) {
      return model.products;
    }
    throw Exception('API error: ${model.code}');
  }
}
