import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/network/api_service.dart';
import '../models/cart_model.dart';
import '../remote/cart_remote_data_source.dart';

abstract class CartRepository {
  Future<Either<String, CartModel>> getCart();

  Future<Either<String, void>> addToCart(String productId, {int quantity = 1});
  Future<Either<String, CartModel>> removeFromCart(String productId);
  Future<Either<String, CartModel>> updateCartItemCount(
    String productId,
    int count,
  );
}

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, CartModel>> getCart() async {
    if (!ApiService().hasToken()) {
      return Left("You must be logged in to view the cart");
    }
    try {
      final cart = await remoteDataSource.getCart();
      return Right(cart);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> addToCart(
    String productId, {
    int quantity = 1,
  }) async {
    if (!ApiService().hasToken()) {
      return Left("You must be logged in to add products to the cart");
    }
    try {
      await remoteDataSource.addToCart(productId, quantity: quantity);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, CartModel>> removeFromCart(String productId) async {
    if (!ApiService().hasToken()) {
      return Left("You must be logged in to remove products from the cart");
    }
    try {
      final cart = await remoteDataSource.removeFromCart(productId);
      return Right(cart);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, CartModel>> updateCartItemCount(
    String productId,
    int count,
  ) async {
    if (!ApiService().hasToken()) {
      return Left("You must be logged in to update product quantity");
    }
    try {
      final cart = await remoteDataSource.updateCartItemCount(productId, count);
      return Right(cart);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
