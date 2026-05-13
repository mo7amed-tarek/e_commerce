import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/wishlist_repository.dart';


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
  List<Object?> get props => [products, wishlistIds, products.length];
}

class WishlistError extends WishlistState {
  final String message;
  WishlistError(this.message);

  @override
  List<Object?> get props => [message];
}

class WishlistSuccess extends WishlistState {
  final String message;
  WishlistSuccess(this.message);

  @override
  List<Object?> get props => [message];
}


class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepository wishlistRepository;

  WishlistCubit({required this.wishlistRepository}) : super(WishlistInitial());

  static WishlistCubit get(context) => BlocProvider.of(context);

  Set<String> _wishlistIds = {};

  Future<void> getWishlist({bool silent = false}) async {
    if (!silent) emit(WishlistLoading());
    final result = await wishlistRepository.getWishlist();
    result.fold(
      (error) {
        emit(WishlistError(error));
      }, 
      (products) {
        _wishlistIds = products.map((p) => p.id).toSet();
        emit(WishlistLoaded(products: List.from(products), wishlistIds: Set.from(_wishlistIds)));
      }
    );
  }

  Future<void> toggleWishlist(String productId, {Product? product}) async {
    if (_wishlistIds.contains(productId)) {
      await removeFromWishlist(productId);
    } else {
      await addToWishlist(productId, product: product);
    }
  }

  Future<void> addToWishlist(String productId, {Product? product}) async {
    _wishlistIds.add(productId);
    
    final result = await wishlistRepository.addToWishlist(productId);
    result.fold(
      (error) {
        _wishlistIds.remove(productId);
        emit(WishlistError(error));
      },
      (_) async {
        emit(WishlistSuccess("Added to wishlist"));
        await getWishlist(silent: true);
      }
    );
  }

  Future<void> removeFromWishlist(String productId) async {
    _wishlistIds.remove(productId);
    
    final result = await wishlistRepository.removeFromWishlist(productId);
    result.fold(
      (error) {
        _wishlistIds.add(productId);
        emit(WishlistError(error));
      },
      (_) async {
        emit(WishlistSuccess("Removed from wishlist"));
        await getWishlist(silent: true);
      }
    );
  }

  bool isInWishlist(String productId) {
    return _wishlistIds.contains(productId);
  }
}
