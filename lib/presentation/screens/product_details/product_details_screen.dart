import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get_it/get_it.dart';

import '../../cubits/cart_cubit.dart';
import '../../cubits/wishlist_cubit.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/products_repository.dart';
import '../../../data/remote/products_remote_data_source.dart';
import '../../../core/network/api_service.dart';
import '../cart/cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({Key? key, required this.productId})
    : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Product? _product;
  bool _loading = true;
  String? _error;
  int _imageIndex = 0;
  String? _selectedSize;
  int _selectedColorIndex = 0;
  bool _isExpanded = false;
  int _quantity = 1;
  bool _justAdded = false;
  bool _isLoading = false;

  final List<String> _sizes = ['38', '39', '40', '41', '42'];
  final List<Color> _colors = [
    Colors.black,
    AppColors.discountColor,
    AppColors.warning,
    Colors.green,
    Colors.brown,
  ];

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      final repo = ProductsRepositoryImpl(
        remoteDataSource: ProductsRemoteDataSource(
          apiService: GetIt.instance<ApiService>(),
        ),
      );
      final result = await repo.getProductById(widget.productId);
      result.fold(
        (error) => setState(() {
          _error = error;
          _loading = false;
        }),
        (product) => setState(() {
          _product = product;
          _loading = false;
        }),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
        ),
        title: const Text(
          'Product Details',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // ✅ FIX: read isInWishlist from state directly so icon reacts instantly
          BlocBuilder<WishlistCubit, WishlistState>(
            builder: (context, state) {
              final isInWishlist = _product != null
                  ? (state is WishlistLoaded
                        ? state.wishlistIds.contains(_product!.id)
                        : context.read<WishlistCubit>().isInWishlist(
                            _product!.id,
                          ))
                  : false;

              return IconButton(
                onPressed: _product != null
                    ? () => context.read<WishlistCubit>().toggleWishlist(
                        _product!.id,
                        product: _product, // ✅ pass full product object
                      )
                    : null,
                icon: Icon(
                  isInWishlist ? Icons.favorite : Icons.favorite_border,
                  color: isInWishlist
                      ? AppColors.discountColor
                      : AppColors.grey,
                ),
              );
            },
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            ),
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.black,
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : _product != null
          ? _buildContent()
          : const SizedBox(),
      bottomNavigationBar: _product != null ? _buildBottomBar() : null,
    );
  }

  Widget _buildContent() {
    final product = _product!;
    final allImages = [product.imageCover, ...product.images];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 280,
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: allImages.length,
                  onPageChanged: (i) => setState(() => _imageIndex = i),
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: allImages[index],
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          Container(color: AppColors.lightGrey),
                    );
                  },
                ),
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AnimatedSmoothIndicator(
                      activeIndex: _imageIndex,
                      count: allImages.length,
                      effect: const WormEffect(
                        dotHeight: 6,
                        dotWidth: 6,
                        activeDotColor: AppColors.primary,
                        dotColor: AppColors.lightGrey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(product.title, style: AppTextStyles.heading1),
                    ),
                    Text(
                      'EGP ${(_quantity * product.price).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('${(product.sold / 1000).toStringAsFixed(1)}k Sold'),
                    const SizedBox(width: 12),
                    RatingBarIndicator(
                      rating: product.ratingsAverage,
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: AppColors.starColor),
                      itemCount: 5,
                      itemSize: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${product.ratingsAverage.toStringAsFixed(1)} (${product.ratingsQuantity})',
                      style: AppTextStyles.smallGrey,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.lightGrey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (_quantity > 1) setState(() => _quantity--);
                            },
                            icon: const Icon(
                              Icons.remove,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                          ),
                          Text(
                            '$_quantity',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() => _quantity++),
                            icon: const Icon(
                              Icons.add,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  _isExpanded
                      ? product.description
                      : product.description.length > 120
                      ? product.description.substring(0, 120)
                      : product.description,
                  style: AppTextStyles.bodyGrey,
                ),
                if (product.description.length > 120)
                  GestureDetector(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    child: Text(
                      _isExpanded ? '...less' : '...read more',
                      style: const TextStyle(color: AppColors.primary),
                    ),
                  ),
                const SizedBox(height: 16),
                const Text(
                  'Size',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  children: _sizes.map((size) {
                    final isSelected = _selectedSize == size;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedSize = size),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.lightGrey,
                        ),
                        child: Center(
                          child: Text(
                            size,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Color',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(_colors.length, (index) {
                    final isSelected = _selectedColorIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColorIndex = index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _colors[index],
                          border: isSelected
                              ? Border.all(color: AppColors.primary, width: 2)
                              : null,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total price',
                style: TextStyle(color: AppColors.grey, fontSize: 12),
              ),
              Text(
                'EGP ${(_quantity * _product!.price).toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: (_justAdded || _isLoading)
                  ? null
                  : () async {
                      setState(() => _isLoading = true);
                      await context.read<CartCubit>().addToCart(
                        _product!.id,
                        quantity: _quantity,
                      );
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                          _justAdded = true;
                        });
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) setState(() => _justAdded = false);
                        });
                      }
                    },
              icon: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      _justAdded ? Icons.check : Icons.shopping_cart,
                      size: 18,
                      color: Colors.white,
                    ),
              label: Text(
                _isLoading
                    ? "Adding..."
                    : _justAdded
                    ? "Added"
                    : "Add to cart",
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _justAdded ? Colors.green : AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
