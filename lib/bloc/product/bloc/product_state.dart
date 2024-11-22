import 'package:luxe_loft/models/product.dart';

abstract class ProductState {}

class ProductInitialState extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductLoadedState extends ProductState {
  final Map<String, List<Product>> productsByCategory;
  final Map<String, dynamic>? userData;

  ProductLoadedState(this.productsByCategory, this.userData);
}

class ProductErrorState extends ProductState {
  final String errorMessage;

  ProductErrorState(this.errorMessage);


}
