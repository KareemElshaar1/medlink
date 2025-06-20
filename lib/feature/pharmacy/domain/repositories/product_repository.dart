import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> searchProducts(String query);
  Future<Product> getProductById(String id);
  Future<List<Product>> getProductsByCategory(String category);
  Future<List<Product>> getFeaturedProducts();
}
