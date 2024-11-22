import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:luxe_loft/models/product.dart';

import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  ProductBloc() : super(ProductInitialState()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<SignOutEvent>(_onSignOut);
  }

  Future<void> _onLoadProducts(
      LoadProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoadingState());
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('products').get();

      Map<String, List<Product>> categorizedProducts = {};

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Product product = Product.fromJson(data);
        String category = product.category;

        if (categorizedProducts.containsKey(category)) {
          categorizedProducts[category]!.add(product);
        } else {
          categorizedProducts[category] = [product];
        }
      }

      Map<String, dynamic>? userData = await _fetchUserData();
      emit(ProductLoadedState(categorizedProducts, userData));
    } catch (e) {
      emit(ProductErrorState('Error fetching products: $e'));
    }
  }

  void _onSignOut(SignOutEvent event, Emitter<ProductState> emit) {
    // Add your sign-out logic here
  }

  Future<Map<String, dynamic>?> _fetchUserData() async {
    if (user == null) return null;
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('users').doc(user!.uid).get();
      return doc.data();
    } catch (e) {
      return null;
    }
  }
}
