import 'package:ecommerce/core/api/api_constants.dart';
import '../models/product_model.dart';
import '../../core/network/api_service.dart';

class ProductsRemoteDataSource {
  final ApiService apiService;

  ProductsRemoteDataSource({required this.apiService});

  Future<List<Product>> getProducts() async {
    final response = await apiService.get(ApiConstants.products);
    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((e) => Product.fromJson(e)).toList();
  }

  Future<List<Product>> getProductsByCategory(String categoryId) async {
    final response = await apiService.get(
      ApiConstants.products,
      queryParameters: {'category': categoryId},
    );
    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((e) => Product.fromJson(e)).toList();
  }

  Future<Product> getProductById(String productId) async {
    final response = await apiService.get(
      '${ApiConstants.productById}$productId',
    );
    return Product.fromJson(response.data['data']);
  }

  Future<List<Category>> getCategories() async {
    final response = await apiService.get(ApiConstants.categories);
    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((e) => Category.fromJson(e)).toList();
  }

  Future<Category> getCategoryById(String categoryId) async {
    final response = await apiService.get(
      '${ApiConstants.categoryById}$categoryId',
    );
    return Category.fromJson(response.data['data']);
  }
}
