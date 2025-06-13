import '../data/product.dart';

abstract class ProductRepository {
  Future<List<Product>> searchProducts(String name);
}
