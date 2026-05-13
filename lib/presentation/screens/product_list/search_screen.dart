import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/products_cubit.dart';
import '../../cubits/cart_cubit.dart';
import '../../cubits/wishlist_cubit.dart';
import '../../widgets/shared_widgets.dart';
import '../../../core/theme/app_theme.dart';
import '../product_details/product_details_screen.dart';

class SearchScreen extends StatefulWidget {
  final String initialQuery;
  const SearchScreen({Key? key, required this.initialQuery}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    context.read<ProductsCubit>().searchProducts(widget.initialQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: false,
            onSubmitted: (value) => context.read<ProductsCubit>().searchProducts(value),
            decoration: const InputDecoration(
              hintText: 'Search products...',
              hintStyle: TextStyle(color: AppColors.grey, fontSize: 13),
              prefixIcon: Icon(Icons.search, color: AppColors.grey, size: 20),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const ProductsLoadingGrid();
          }
          if (state is ProductsError) {
            return Center(child: Text(state.message));
          }
          if (state is ProductsLoaded) {
            if (state.products.isEmpty) {
              return _buildEmptyResults();
            }
            return _buildResultsGrid(state.products);
          }
          return const Center(child: Text('Type to search...'));
        },
      ),
    );
  }

  Widget _buildResultsGrid(List<dynamic> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isInWishlist = context.watch<WishlistCubit>().isInWishlist(product.id);
        
        return ProductCard(
          product: product,
          isInWishlist: isInWishlist,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsScreen(productId: product.id),
            ),
          ),
          onAddToCart: () => context.read<CartCubit>().addToCart(product.id),
          onWishlistToggle: () => context.read<WishlistCubit>().toggleWishlist(product.id, product: product),
        );
      },
    );
  }

  Widget _buildEmptyResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: AppColors.grey.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text(
            'No results found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          const Text('Try different keywords', style: TextStyle(color: AppColors.grey)),
        ],
      ),
    );
  }
}
