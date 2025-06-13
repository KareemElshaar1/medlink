import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'cubit/product_cubit.dart';
import '../../../core/utils/color_manger.dart';
import '../../../core/helper/shared_pref_helper.dart';
import '../../../di.dart';
import '../domain/entities/product.dart';
import 'ProductDetailsPage.dart';
import 'CartPage.dart';
import 'dart:math';

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
          hintText: 'ابحث عن دواء...',
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
        },
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            context.read<ProductCubit>().searchProducts(value);
          }
        },
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2);
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
            size: 64.w,
            color: ColorsManager.error,
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.8, 0.8)),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(
              color: ColorsManager.error,
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: _searchRandomProduct,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.primary,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'حاول مرة أخرى',
              style: TextStyle(
                color: ColorsManager.background,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 400.ms)
              .scale(begin: const Offset(0.8, 0.8)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<ProductCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: ColorsManager.background,
            appBar: AppBar(
              title: Text(
                'الصيدلية',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ColorsManager.background,
                  fontSize: 20.sp,
                ),
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),
              backgroundColor: ColorsManager.primary,
              elevation: 0,
              centerTitle: true,
              iconTheme: const IconThemeData(color: ColorsManager.background),
              actions: [
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        size: 24.w,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartPage(),
                          ),
                        ).then((_) => _loadCartItemCount());
                      },
                    ),
                    if (cartItemCount > 0)
                      Positioned(
                        right: 8.w,
                        top: 8.h,
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: ColorsManager.error,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16.w,
                            minHeight: 16.h,
                          ),
                          child: Text(
                            '$cartItemCount',
                            style: TextStyle(
                              color: ColorsManager.background,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(begin: const Offset(0.8, 0.8)),
              ],
            ),
            body: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildSearchBar()),
                    if (state is ProductLoading)
                      const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorsManager.primary,
                          ),
                        ),
                      )
                    else if (state is ProductError)
                      SliverFillRemaining(
                          child: _buildErrorState(state.message))
                    else if (state is ProductSuccess)
                      SliverPadding(
                        padding: EdgeInsets.all(16.w),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16.w,
                            mainAxisSpacing: 16.h,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                                _buildProductCard(state.products[index], index),
                            childCount: state.products.length,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
