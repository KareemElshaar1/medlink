import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/product.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _repository;

  ProductCubit()
      : _repository = GetIt.I<ProductRepository>(),
        super(ProductInitial());

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) return;

    emit(ProductLoading());
    try {
      final products = await _repository.searchProducts(query);
      emit(ProductSuccess(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> getProductById(String id) async {
    emit(ProductLoading());
    try {
      final product = await _repository.getProductById(id);
      emit(ProductSuccess([product]));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> getProductsByCategory(String category) async {
    emit(ProductLoading());
    try {
      final products = await _repository.getProductsByCategory(category);
      emit(ProductSuccess(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> getFeaturedProducts() async {
    emit(ProductLoading());
    try {
      final products = await _repository.getFeaturedProducts();
      emit(ProductSuccess(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {
  final List<Product> products;

  ProductSuccess(this.products);
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}
