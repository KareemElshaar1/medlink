import 'package:dio/dio.dart';
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio _dio;

  ProductRemoteDataSourceImpl() : _dio = Dio() {
    _dio.options.baseUrl = 'http://moelshafey.xyz/API/MD';
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
  }

  @override
  Future<List<ProductModel>> searchProducts(String name) async {
    try {
      print('Searching for: $name');
      final response =
          await _dio.get('/search.php', queryParameters: {'name': name});
      print('API Response: ${response.data}');

      if (response.data['error'] == false && response.data['code'] == 200) {
        final List<dynamic> productsJson = response.data['products'];
        return productsJson.map((json) => ProductModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final response =
          await _dio.get('/search.php', queryParameters: {'id': id});
      if (response.data['error'] == false && response.data['code'] == 200) {
        final List<dynamic> productsJson = response.data['products'];
        if (productsJson.isNotEmpty) {
          return ProductModel.fromJson(productsJson.first);
        }
      }
      throw Exception('Product not found');
    } catch (e) {
      throw Exception('Failed to get product details');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await _dio
          .get('/search.php', queryParameters: {'category': category});
      if (response.data['error'] == false && response.data['code'] == 200) {
        final List<dynamic> productsJson = response.data['products'];
        return productsJson.map((json) => ProductModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      final response =
          await _dio.get('/search.php', queryParameters: {'name': 'بانادول'});
      if (response.data['error'] == false && response.data['code'] == 200) {
        final List<dynamic> productsJson = response.data['products'];
        return productsJson.map((json) => ProductModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
