import 'package:ecommerce/core/api/api_constants.dart';
import 'package:ecommerce/core/network/api_service.dart';
import 'package:ecommerce/data/models/cart_model.dart';

class CartRemoteDataSource {
  final ApiService apiService;

  CartRemoteDataSource({required this.apiService});

  Future<CartModel> getCart() async {
    if (!apiService.hasToken()) throw Exception("User not logged in");

    final response = await apiService.get(
      ApiConstants.cart,
      queryParameters: {"populate": "product"},
    );

    if (response.statusCode == 200) {
      return CartModel.fromJson(response.data);
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized. Please login again.");
    } else {
      throw Exception(response.data['message'] ?? "Unknown error");
    }
  }

  Future<void> addToCart(String productId, {int quantity = 1}) async {
    if (!apiService.hasToken()) throw Exception("User not logged in");

    final response = await apiService.post(
      ApiConstants.cart,
      data: {"productId": productId, "count": quantity},
    );

    if (response.statusCode == 401) {
      throw Exception("Unauthorized. Please login again.");
    } else if (response.statusCode != 200) {
      throw Exception(response.data['message'] ?? "Unknown error");
    }
  }

  Future<CartModel> removeFromCart(String productId) async {
    if (!apiService.hasToken()) throw Exception("User not logged in");

    final response = await apiService.delete('${ApiConstants.cart}/$productId');

    if (response.statusCode == 200) {
      return CartModel.fromJson(response.data);
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized. Please login again.");
    } else {
      throw Exception(response.data['message'] ?? "Unknown error");
    }
  }

  Future<CartModel> updateCartItemCount(String productId, int count) async {
    if (!apiService.hasToken()) throw Exception("User not logged in");

    final response = await apiService.put(
      '${ApiConstants.cart}/$productId',
      data: {"count": count},
    );

    if (response.statusCode == 200) {
      return CartModel.fromJson(response.data);
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized. Please login again.");
    } else {
      throw Exception(response.data['message'] ?? "Unknown error");
    }
  }

  Future<void> clearCart() async {
    if (!apiService.hasToken()) throw Exception("User not logged in");

    final response = await apiService.delete(ApiConstants.cart);

    if (response.statusCode == 401) {
      throw Exception("Unauthorized. Please login again.");
    }
  }
}
