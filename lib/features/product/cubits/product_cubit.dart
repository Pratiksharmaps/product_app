import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_app/services/api_client.dart';
import '../models/product_model.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> allProducts;
  final List<Product> filteredProducts;

  ProductLoaded(this.allProducts, this.filteredProducts);
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}

class ProductCubit extends Cubit<ProductState> {
  final ApiClient _apiClient;
  List<Product> _allProducts = [];

  ProductCubit(this._apiClient) : super(ProductInitial());

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    try {
      _allProducts = await _apiClient.getProducts();
      emit(ProductLoaded(_allProducts, _allProducts));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void searchProducts(String query) {
    if (state is ProductLoaded) {
      final filteredProducts = _allProducts.where((product) =>
          product.title.toLowerCase().contains(query.toLowerCase()) ||
          (product.subtitle?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
          product.description.toLowerCase().contains(query.toLowerCase())
      ).toList();
      emit(ProductLoaded(_allProducts, filteredProducts));
    }
  }
}

