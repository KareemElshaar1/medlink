import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SearchProducts {
  final ProductRepository repository;

  SearchProducts(this.repository);

  Future<Either<Failure, List<Product>>> call(String name) async {
    try {
      final products = await repository.searchProducts(name);
      return Right(products);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
