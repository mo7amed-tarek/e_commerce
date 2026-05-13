import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/products_repository.dart';

// States
abstract class ProductsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}
class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final String? categoryId;

  ProductsLoaded({required this.products, this.categoryId});

  @override
  List<Object?> get props => [products, categoryId];
}

class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepository productsRepository;

  ProductsCubit({required this.productsRepository}) : super(ProductsInitial());

  static ProductsCubit get(context) => BlocProvider.of(context);

  Future<void> loadProducts({String? categoryId}) async {
    emit(ProductsLoading());

    final result = categoryId != null
        ? await productsRepository.getProductsByCategory(categoryId)
        : await productsRepository.getProducts();

    result.fold(
      (error) => emit(ProductsError(error)),
      (products) => emit(ProductsLoaded(products: products, categoryId: categoryId)),
    );
  }
}
