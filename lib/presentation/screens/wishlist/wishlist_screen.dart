import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../cubits/wishlist_cubit.dart';
import '../../cubits/cart_cubit.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/product_model.dart';
import '../product_details/product_details_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistCubit>().getWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
          Expanded(
            child: BlocBuilder<WishlistCubit, WishlistState>(
              builder: (context, state) {
                if (state is WishlistLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is WishlistError) {
                  return Center(child: Text(state.message));
                }
                if (state is WishlistLoaded) {
                  if (state.products.isEmpty) {
                    return _buildEmptyWishlist();
                  }
                  return _buildWishlistContent(context, state.products);
                }

                return _buildEmptyWishlist();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWishlist() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: AppColors.lightGrey),
          SizedBox(height: 16),
          Text(
            'Your wishlist is empty',
            style: TextStyle(fontSize: 18, color: AppColors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Save items you love here',
            style: TextStyle(color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistContent(BuildContext context, List<Product> products) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildWishlistItem(context, product);
      },
    );
  }

  Widget _buildWishlistItem(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(productId: product.id),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: product.imageCover,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  color: AppColors.lightGrey,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand + delete
                    Row(
                      children: [
                        if (product.brand != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              product.brand!.name,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => context
                              .read<WishlistCubit>()
                              .removeFromWishlist(product.id),
                          child: const Icon(
                            Icons.favorite,
                            color: AppColors.discountColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: AppColors.primary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          'EGP ${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        if (product.priceAfterDiscount != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              'EGP ${product.priceAfterDiscount!.toStringAsFixed(0)}',
                              style: AppTextStyles.priceOld,
                            ),
                          ),
                        const Spacer(),
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () =>
                                context.read<CartCubit>().addToCart(product.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
