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
  final List<Category> categories;
  final List<Product> featuredProducts;
  final Set<String> availableSubCategoryIds;

  HomeLoaded({
    required this.categories,
    required this.featuredProducts,
    required this.availableSubCategoryIds,
  });

  @override
  List<Object?> get props => [
    categories,
    featuredProducts,
    availableSubCategoryIds,
  ];
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

    categoriesResult.fold((error) => emit(HomeError(error)), (categories) {
      productsResult.fold((error) => emit(HomeError(error)), (products) {
        final Set<String> workingCategoryIds = products
            .where((p) => p.category?.id != null)
            .map<String>((p) => p.category!.id)
            .toSet();

        final Set<String> workingSubCategoryIds = products
            .where((p) => p.subcategory != null)
            .expand((p) => p.subcategory!)
            .map<String>((s) => s.id)
            .toSet();

        final List<Category> filteredCats = categories
            .where((cat) => workingCategoryIds.contains(cat.id))
            .toList();

        final finalCategories = filteredCats.isNotEmpty
            ? filteredCats
            : categories;

        emit(
          HomeLoaded(
            categories: finalCategories,
            featuredProducts: products,
            availableSubCategoryIds: workingSubCategoryIds,
          ),
        );
      });
    });
  }
}
