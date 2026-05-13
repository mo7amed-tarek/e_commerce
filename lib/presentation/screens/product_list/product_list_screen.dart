import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/products_cubit.dart';
import '../../cubits/cart_cubit.dart';
import '../../cubits/wishlist_cubit.dart';
import '../../widgets/shared_widgets.dart';
import '../../../core/theme/app_theme.dart';
import '../product_details/product_details_screen.dart';
import '../../../data/repositories/products_repository.dart';
import '../../../core/network/api_service.dart';
import '../../../data/remote/products_remote_data_source.dart';

class ProductListScreen extends StatelessWidget {
  final String? categoryId;
  final String categoryName;

  const ProductListScreen({
    Key? key,
    this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsCubit(
        productsRepository: ProductsRepositoryImpl(
          remoteDataSource: ProductsRemoteDataSource(apiService: ApiService()),
        ),
      )..loadProducts(categoryId: categoryId),
      child: _ProductListView(categoryName: categoryName),
    );
  }
}

class _ProductListView extends StatelessWidget {
  final String categoryName;

  const _ProductListView({Key? key, required this.categoryName})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          'Route',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: AppColors.primary),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'What do you search for?',
                  hintStyle: TextStyle(color: AppColors.grey, fontSize: 13),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.grey,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          // Products Grid
          Expanded(
            child: BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                if (state is ProductsLoading) {
                  return const ProductsLoadingGrid();
                }
                if (state is ProductsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                          color: AppColors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: const TextStyle(color: AppColors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<ProductsCubit>().loadProducts(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                if (state is ProductsLoaded) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.62,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return BlocBuilder<WishlistCubit, WishlistState>(
                        builder: (context, wishState) {
                          final isInWishlist = context
                              .read<WishlistCubit>()
                              .isInWishlist(product.id);
                          return ProductCard(
                            product: product,
                            isInWishlist: isInWishlist,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailsScreen(productId: product.id),
                              ),
                            ),
                            onAddToCart: () =>
                                context.read<CartCubit>().addToCart(product.id),
                            onWishlistToggle: () => context
                                .read<WishlistCubit>()
                                .toggleWishlist(product.id),
                          );
                        },
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
