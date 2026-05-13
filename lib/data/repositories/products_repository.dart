import 'package:dartz/dartz.dart';
import '../models/product_model.dart';
import '../remote/products_remote_data_source.dart';

abstract class ProductsRepository {
  Future<Either<String, List<Product>>> getProducts();
  Future<Either<String, List<Product>>> getProductsByCategory(String categoryId);
  Future<Either<String, Product>> getProductById(String productId);
  Future<Either<String, List<Category>>> getCategories();
  Future<Either<String, List<Product>>> searchProducts(String keyword);
}

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;

  ProductsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<Product>>> searchProducts(String keyword) async {
    try {
      final products = await remoteDataSource.searchProducts(keyword);
      return Right(products);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Product>>> getProducts() async {
    try {
      final products = await remoteDataSource.getProducts();
      return Right(products);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Product>>> getProductsByCategory(
      String categoryId) async {
    try {
      final products =
          await remoteDataSource.getProductsByCategory(categoryId);
      return Right(products);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Product>> getProductById(String productId) async {
    try {
      final product = await remoteDataSource.getProductById(productId);
      return Right(product);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Category>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
