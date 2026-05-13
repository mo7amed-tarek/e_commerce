import 'package:ecommerce/auth/presentation/cubits/auth_cubit.dart';
import 'package:ecommerce/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../cubits/home_cubit.dart';
import '../../cubits/cart_cubit.dart';
import '../../cubits/wishlist_cubit.dart';
import '../../widgets/shared_widgets.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/product_model.dart';
import '../product_details/product_details_screen.dart';
import '../product_list/product_list_screen.dart';
import '../categories/categories_screen.dart';
import '../wishlist/wishlist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bannerIndex = 0;
  int _navIndex = 0;
  final PageController _pageController = PageController();

  bool _autoSlideActive = false;

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'UP TO\n25% OFF',
      'subtitle': 'For all Headphones\n& AirPods',
      'bgColor': const Color(0xFFFFD600),
      'textColor': AppColors.black,
    },
    {
      'title': 'NEW SEASON\nCOLLECTION',
      'subtitle': 'Explore the latest\nfashion trends',
      'bgColor': AppColors.primary,
      'textColor': AppColors.white,
    },
  ];

  List<Widget> get _screens => [
    _buildHomeBody(),
    const CategoriesScreen(),
    const WishlistScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHomeData();
    context.read<CartCubit>().getCart();
    context.read<WishlistCubit>().getWishlist();

    _autoSlideActive = true;
    Future.delayed(const Duration(seconds: 3), _autoSlideBanner);
  }

  @override
  void dispose() {
    _autoSlideActive = false;
    _pageController.dispose();
    super.dispose();
  }

  void _autoSlideBanner() {
    if (!mounted || !_autoSlideActive) return;
    if (!_pageController.hasClients) {
      Future.delayed(const Duration(seconds: 1), _autoSlideBanner);
      return;
    }

    final nextPage = (_bannerIndex + 1) % _banners.length;
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() => _bannerIndex = nextPage);
    Future.delayed(const Duration(seconds: 3), _autoSlideBanner);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Welcome, ${user?.name ?? 'Guest'}',
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: IndexedStack(index: _navIndex, children: _screens),
      bottomNavigationBar: RouteBottomNavBar(
        currentIndex: _navIndex,
        onTap: (index) => setState(() => _navIndex = index),
      ),
    );
  }

  // ================= HOME BODY =================
  Widget _buildHomeBody() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) return const ProductsLoadingGrid();
        if (state is HomeError) return _buildError(state.message);
        if (state is HomeLoaded) return _buildContent(context, state);
        return const SizedBox();
      },
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: AppColors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<HomeCubit>().loadHomeData(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeLoaded state) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildSearchBar()),
        SliverToBoxAdapter(child: _buildBanner()),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(
          child: _buildCategoriesSection(context, state.categories),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        BlocBuilder<WishlistCubit, WishlistState>(
          builder: (context, wishlistState) {
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = state.featuredProducts[index];

                    final isInWishlist = wishlistState is WishlistLoaded
                        ? wishlistState.wishlistIds.contains(product.id)
                        : context.read<WishlistCubit>().isInWishlist(
                            product.id,
                          );

                    return BlocBuilder<CartCubit, CartState>(
                      builder: (context, cartState) {
                        final isLoading = cartState is CartLoading;

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
                          onAddToCart: isLoading
                              ? null
                              : () => context.read<CartCubit>().addToCart(
                                  product.id,
                                ),
                          onWishlistToggle: () => context
                              .read<WishlistCubit>()
                              .toggleWishlist(product.id, product: product),
                        );
                      },
                    );
                  },
                  childCount: state.featuredProducts.length > 6
                      ? 6
                      : state.featuredProducts.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.62,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
              ),
            );
          },
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
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
            prefixIcon: Icon(Icons.search, color: AppColors.grey, size: 20),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _bannerIndex = index),
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return _buildBannerItem(
                title: banner['title'],
                subtitle: banner['subtitle'],
                bgColor: banner['bgColor'],
                textColor: banner['textColor'],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSmoothIndicator(
          activeIndex: _bannerIndex,
          count: _banners.length,
          effect: const WormEffect(
            dotHeight: 6,
            dotWidth: 20,
            activeDotColor: AppColors.primary,
            dotColor: AppColors.lightGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildBannerItem({
    required String title,
    required String subtitle,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            flex: 2,
            child: Icon(Icons.headphones, size: 90, color: Colors.black26),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(
    BuildContext context,
    List<Category> categories,
  ) {
    return Column(
      children: [
        _buildSectionHeader('Categories'),
        SizedBox(
          height: 90,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CategoryItem(
                  category: cat,
                  isSelected: false,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductListScreen(
                        categoryId: cat.id,
                        categoryName: cat.name,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(title, style: AppTextStyles.heading1),
    );
  }
}
