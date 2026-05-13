import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../cubits/home_cubit.dart';
import '../../cubits/cart_cubit.dart';
import '../../widgets/shared_widgets.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/product_model.dart';
import '../product_list/product_list_screen.dart';
import '../cart/cart_screen.dart';

class CategoriesScreen extends StatefulWidget {
  final String? gender;
  const CategoriesScreen({Key? key, this.gender}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().getCart();
  }

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
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              final count = context.read<CartCubit>().cartCount;
              return Stack(
                children: [
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    ),
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: AppColors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) return const ProductsLoadingGrid();
          if (state is HomeLoaded) {
            return _buildContent(context, state.categories);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Category> categories) {
    return Column(
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
                prefixIcon: Icon(Icons.search, color: AppColors.grey, size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Text(
            widget.gender == 'women'
                ? "Women's Fashion"
                : widget.gender == 'men'
                ? "Men's Fashion"
                : 'Categories',
            style: AppTextStyles.heading1,
          ),
        ),
        Expanded(
          child: Row(
            children: [
              // Left Side - Categories List
              Container(
                width: 130,
                color: AppColors.lightGrey,
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = _selectedCategory?.id == cat.id;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedCategory = cat);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.lightGrey,
                          border: isSelected
                              ? const Border(
                                  left: BorderSide(
                                    color: AppColors.primary,
                                    width: 3,
                                  ),
                                )
                              : null,
                        ),
                        child: Text(
                          cat.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Right Side - Subcategories / Preview
              Expanded(
                child: _selectedCategory == null
                    ? _buildCategoriesGrid(context, categories)
                    : _buildSelectedCategoryContent(
                        context,
                        _selectedCategory!,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesGrid(BuildContext context, List<Category> categories) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ProductListScreen(categoryId: cat.id, categoryName: cat.name),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: cat.image,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        Container(color: AppColors.lightGrey),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Text(
                      cat.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedCategoryContent(
    BuildContext context,
    Category category,
  ) {
    return Column(
      children: [
        // Image preview
        Container(
          height: 120,
          width: double.infinity,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: category.image,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) =>
                  Container(color: AppColors.lightGrey),
            ),
          ),
        ),
        // Sub-items (simulated)
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              _buildSubCategoryTile(context, 'T-Shirts', category),
              _buildSubCategoryTile(context, 'Shirts', category),
              _buildSubCategoryTile(context, 'Jeans', category),
              _buildSubCategoryTile(context, 'Pants', category),
              _buildSubCategoryTile(context, 'Footwear', category),
              _buildSubCategoryTile(context, 'Bags', category),
              _buildSubCategoryTile(context, 'T-Shirts', category),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubCategoryTile(
    BuildContext context,
    String name,
    Category category,
  ) {
    return ListTile(
      dense: true,
      title: Text(name, style: const TextStyle(fontSize: 13)),
      trailing: const Icon(
        Icons.chevron_right,
        size: 16,
        color: AppColors.grey,
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ProductListScreen(categoryId: category.id, categoryName: name),
        ),
      ),
    );
  }
}
