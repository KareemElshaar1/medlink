import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Product>> searchProducts(String query) async {
    return await _remoteDataSource.searchProducts(query);
  }

  @override
  Future<Product> getProductById(String id) async {
    return await _remoteDataSource.getProductById(id);
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    return await _remoteDataSource.getProductsByCategory(category);
  }

  @override
  Future<List<Product>> getFeaturedProducts() async {
    return await _remoteDataSource.getFeaturedProducts();
  }
}
