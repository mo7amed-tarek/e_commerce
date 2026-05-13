import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/products_repository.dart';

// States
abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Product> featuredProducts;
  final List<Category> categories;

  HomeLoaded({required this.featuredProducts, required this.categories});

  @override
  List<Object?> get props => [featuredProducts, categories];
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class HomeCubit extends Cubit<HomeState> {
  final ProductsRepository productsRepository;

  HomeCubit({required this.productsRepository}) : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);

  Future<void> loadHomeData() async {
    emit(HomeLoading());

    final productsResult = await productsRepository.getProducts();
    final categoriesResult = await productsRepository.getCategories();

    productsResult.fold(
      (error) => emit(HomeError(error)),
      (products) {
        categoriesResult.fold(
          (error) => emit(HomeError(error)),
          (categories) => emit(
            HomeLoaded(
              featuredProducts: products.take(10).toList(),
              categories: categories,
            ),
          ),
        );
      },
    );
  }
}
