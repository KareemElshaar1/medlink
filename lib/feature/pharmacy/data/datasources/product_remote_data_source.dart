import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> searchProducts(String name);
  Future<ProductModel> getProductById(String id);
  Future<List<ProductModel>> getProductsByCategory(String category);
  Future<List<ProductModel>> getFeaturedProducts();
}
