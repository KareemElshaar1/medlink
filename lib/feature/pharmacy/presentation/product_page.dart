import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helper/shared_pref_helper.dart';
import '../../../core/utils/color_manger.dart';
import '../domain/entities/product.dart';
import 'CartPage.dart';
import 'ProductDetailsPage.dart';
import 'cubit/product_cubit.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final TextEditingController _searchController = TextEditingController();
  int cartItemCount = 0;
  bool _isSearching = false;
  final List<String> _searchKeywords = [
    'pain',
    'fever',
    'cold',
    'headache',
    'vitamin',
    'antibiotic',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchRandomProduct();
      _loadCartItemCount();
    });
  }

  Future<void> _loadCartItemCount() async {
    try {
      String cartJson = await SharedPrefHelper.getString('cart_items');
      if (cartJson.isNotEmpty) {
        List<dynamic> cartList = json.decode(cartJson);
        if (mounted) {
          setState(() {
            cartItemCount = cartList.length;
          });
        }
      }
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchRandomProduct() {
    final random = Random();
    final keyword = _searchKeywords[random.nextInt(_searchKeywords.length)];
    if (mounted) {
      context.read<ProductCubit>().searchProducts(keyword);
    }
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsManager.background,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.primary.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for medicine...',
          hintStyle: TextStyle(
            color: ColorsManager.textMedium,
            fontSize: 16.sp,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: ColorsManager.primary,
            size: 24.w,
          ),
          suffixIcon: _isSearching
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: ColorsManager.error,
                    size: 24.w,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _isSearching = false);
                    _searchRandomProduct();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: ColorsManager.background,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
        onChanged: (value) {
          setState(() => _isSearching = value.isNotEmpty);
          if (value.isNotEmpty) {
            context.read<ProductCubit>().searchProducts(value);
          }
        },
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2);
  }

  Widget _buildProductGrid(List<Product> products) {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildProductCard(products[index], index);
      },
    );
  }

  Widget _buildProductCard(Product product, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              name: product.name,
              image: product.imageUrl,
              price: product.price.toString(),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: ColorsManager.background,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: const [
            BoxShadow(
              color: ColorsManager.shadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.r)),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: ColorsManager.gray.withOpacity(0.1),
                          child: Icon(
                            Icons.image_not_supported,
                            size: 48.w,
                            color: ColorsManager.gray,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: ColorsManager.primary,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        '${product.price} جنيه',
                        style: TextStyle(
                          color: ColorsManager.background,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: ColorsManager.textDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product.manufacturer.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      product.manufacturer,
                      style: TextStyle(
                        color: ColorsManager.textMedium,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: (100 * index).ms)
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48.w,
            color: ColorsManager.error,
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(
              color: ColorsManager.textDark,
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: _searchRandomProduct,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.background,
      appBar: AppBar(
        backgroundColor: ColorsManager.background,
        elevation: 0,
        title: Text(
          'Products',
          style: TextStyle(
            color: ColorsManager.textDark,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: ColorsManager.primary,
                  size: 24.w,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: 8.w,
                  top: 8.h,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: const BoxDecoration(
                      color: ColorsManager.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cartItemCount.toString(),
                      style: TextStyle(
                        color: ColorsManager.background,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ProductSuccess) {
                  if (state.products.isEmpty) {
                    return Center(
                      child: Text(
                        'No products found',
                        style: TextStyle(
                          color: ColorsManager.textMedium,
                          fontSize: 16.sp,
                        ),
                      ),
                    );
                  }
                  return _buildProductGrid(state.products);
                } else if (state is ProductError) {
                  return _buildErrorState(state.message);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
