import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/wishlist_repository.dart';

// States
abstract class WishlistState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<Product> products;
  final Set<String> wishlistIds;

  WishlistLoaded({required this.products, required this.wishlistIds});

  @override
  List<Object?> get props => [products, wishlistIds];
}

class WishlistError extends WishlistState {
  final String message;
  WishlistError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepository wishlistRepository;

  WishlistCubit({required this.wishlistRepository}) : super(WishlistInitial());

  static WishlistCubit get(context) => BlocProvider.of(context);

  Set<String> _wishlistIds = {};
  Set<String> get wishlistIds => _wishlistIds;

  Future<void> getWishlist() async {
    emit(WishlistLoading());
    final result = await wishlistRepository.getWishlist();
    result.fold((error) => emit(WishlistError(error)), (products) {
      _wishlistIds = products.map((p) => p.id).toSet();
      emit(WishlistLoaded(products: products, wishlistIds: _wishlistIds));
    });
  }

  Future<void> toggleWishlist(String productId, {Product? product}) async {
    if (_wishlistIds.contains(productId)) {
      await removeFromWishlist(productId);
    } else {
      await addToWishlist(productId, product: product);
    }
  }

  Future<void> addToWishlist(String productId, {Product? product}) async {
    final result = await wishlistRepository.addToWishlist(productId);
    result.fold((error) => emit(WishlistError(error)), (_) {
      _wishlistIds.add(productId);
      final currentState = state;
      if (currentState is WishlistLoaded && product != null) {
        final updatedProducts = List<Product>.from(currentState.products)
          ..add(product);
        emit(
          WishlistLoaded(
            products: updatedProducts,
            wishlistIds: Set.from(_wishlistIds),
          ),
        );
      }
    });
  }

  Future<void> removeFromWishlist(String productId) async {
    final result = await wishlistRepository.removeFromWishlist(productId);
    result.fold((error) => emit(WishlistError(error)), (_) {
      _wishlistIds.remove(productId);
      final currentState = state;
      if (currentState is WishlistLoaded) {
        final updatedProducts = currentState.products
            .where((p) => p.id != productId)
            .toList();
        emit(
          WishlistLoaded(
            products: updatedProducts,
            wishlistIds: Set.from(_wishlistIds),
          ),
        );
      }
    });
  }

  bool isInWishlist(String productId) => _wishlistIds.contains(productId);
}
