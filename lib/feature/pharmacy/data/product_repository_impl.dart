import 'package:medlink/feature/pharmacy/data/product_remote_data_source.dart';

import '../domain/product_repository.dart';
import 'product.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Product>> searchProducts(String name) {
    return remoteDataSource.searchProducts(name);
  }
}
