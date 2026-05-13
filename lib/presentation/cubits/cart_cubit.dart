import 'package:ecommerce/core/network/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/cart_model.dart';
import '../../data/repositories/cart_repository.dart';

abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}
class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartModel cart;
  CartLoaded({required this.cart});

  @override
  List<Object?> get props => [cart];
}

class CartError extends CartState {
  final String message;
  CartError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CartAddedSuccess extends CartState {
  final String message;
  CartAddedSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class CartCubit extends Cubit<CartState> {
  final CartRepository cartRepository;

  CartCubit({required this.cartRepository}) : super(CartInitial());

  CartModel? _currentCart;

  int get cartCount => _currentCart?.products.length ?? 0;

  Future<void> getCart({bool silent = false}) async {
    if (!ApiService().hasToken()) {
      emit(CartError(message: "You must be logged in to view the cart"));
      return;
    }
    
    if (!silent) emit(CartLoading());
    
    try {
      final result = await cartRepository.getCart();
      result.fold(
        (error) => emit(CartError(message: error)),
        (cart) {
          _currentCart = cart;
          emit(CartLoaded(cart: cart));
        },
      );
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> addToCart(String productId, {int quantity = 1}) async {
    if (!ApiService().hasToken()) {
      emit(CartError(message: "You must be logged in to add products"));
      return;
    }
    
    final result = await cartRepository.addToCart(productId, quantity: quantity);
    result.fold(
      (error) => emit(CartError(message: error)),
      (_) async {
        emit(CartAddedSuccess(message: "Product added to cart successfully"));
        await getCart(silent: true);
      },
    );
  }

  Future<void> removeFromCart(String productId) async {
    emit(CartLoading());
    final result = await cartRepository.removeFromCart(productId);
    result.fold(
      (error) => emit(CartError(message: error)),
      (cart) {
        _currentCart = cart;
        emit(CartLoaded(cart: cart));
      },
    );
  }

  Future<void> updateCount(String productId, int count) async {
    emit(CartLoading());
    final result = await cartRepository.updateCartItemCount(productId, count);
    result.fold(
      (error) => emit(CartError(message: error)),
      (cart) {
        _currentCart = cart;
        emit(CartLoaded(cart: cart));
      },
    );
  }
}
