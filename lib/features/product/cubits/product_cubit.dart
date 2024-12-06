import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product_model.dart';
import '../../../services/api_client.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;

  ProductLoaded(this.products);
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}

class ProductCubit extends Cubit<ProductState> {
  final ApiClient _apiClient;

  ProductCubit(this._apiClient) : super(ProductInitial());

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    try {
      final products = await _apiClient.getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> searchProducts(String query) async {
    emit(ProductLoading());
    try {
      final products = await _apiClient.searchProducts(query);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}

