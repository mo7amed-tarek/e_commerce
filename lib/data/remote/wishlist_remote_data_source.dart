import 'package:ecommerce/core/api/api_constants.dart';
import 'package:ecommerce/core/network/api_service.dart';
import '../models/product_model.dart';

abstract class WishlistRemoteDataSource {
  Future<List<Product>> getWishlist();
  Future<Product> addToWishlist(String productId);
  Future<bool> removeFromWishlist(String productId);
}

class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final ApiService apiService;

  WishlistRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<Product>> getWishlist() async {
    try {
      final response = await apiService.get(ApiConstants.wishlist);

      if (response.statusCode == 200) {
        final data = response.data['data'];

        if (data is! List) {
          throw Exception("Invalid response format: expected a list");
        }

        return data
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(response.data['message'] ?? "Failed to fetch wishlist");
      }
    } catch (e) {
      throw Exception("Error fetching wishlist: $e");
    }
  }

  @override
  Future<Product> addToWishlist(String productId) async {
    try {
      final response = await apiService.post(
        ApiConstants.wishlist,
        data: {'productId': productId},
      );

      if (response.statusCode == 200) {
        final dynamic data = response.data['data'];

        if (data != null && data is Map<String, dynamic>) {
          return Product.fromJson(data);
        }

        if (data != null && data is List && data.isNotEmpty) {
          final firstItem = data.first;
          if (firstItem is Map<String, dynamic>) {
            return Product.fromJson(firstItem);
          } else if (firstItem is Map) {
            return Product.fromJson(Map<String, dynamic>.from(firstItem));
          }
        }

        if (data != null && data is Map) {
          return Product.fromJson(Map<String, dynamic>.from(data));
        }

        throw Exception(
          response.data['message'] ?? "Added to wishlist but no product data",
        );
      } else {
        throw Exception(
          response.data['message'] ?? "Failed to add to wishlist",
        );
      }
    } catch (e) {
      throw Exception("Error adding to wishlist: $e");
    }
  }

  @override
  Future<bool> removeFromWishlist(String productId) async {
    try {
      final response = await apiService.delete(
        '${ApiConstants.wishlist}/$productId',
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
          response.data['message'] ?? "Failed to remove from wishlist",
        );
      }
    } catch (e) {
      throw Exception("Error removing from wishlist: $e");
    }
  }
}
