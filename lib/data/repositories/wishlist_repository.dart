import 'package:dartz/dartz.dart';
import '../models/product_model.dart';
import '../remote/wishlist_remote_data_source.dart';
import 'package:dio/dio.dart';

abstract class WishlistRepository {
  Future<Either<String, List<Product>>> getWishlist();

  Future<Either<String, void>> addToWishlist(String productId);
  Future<Either<String, bool>> removeFromWishlist(String productId);
}

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDataSource remoteDataSource;

  WishlistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<Product>>> getWishlist() async {
    try {
      final wishlist = await remoteDataSource.getWishlist();
      return Right(wishlist);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, void>> addToWishlist(String productId) async {
    try {
      await remoteDataSource.addToWishlist(productId);
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, bool>> removeFromWishlist(String productId) async {
    try {
      final result = await remoteDataSource.removeFromWishlist(productId);
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  String _handleError(dynamic e) {
    if (e is DioException) {
      return e.response?.data['message'] ?? e.message ?? 'Unknown error';
    }
    return e.toString();
  }
}
