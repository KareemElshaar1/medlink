import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:convert';

import '../../../core/utils/color_manger.dart';
import '../../../core/helper/shared_pref_helper.dart';
import '../../../core/routes/page_routes_name.dart';
import '../domain/models/cart_item.dart';
import '../../../feature/pharmacy/presentation/CartPage.dart';
import '../../../feature/google map/presentation/google_map_page.dart';

class ProductDetailsPage extends StatefulWidget {
  final String name;
  final String image;
  final String price;

  const ProductDetailsPage({
    super.key,
    required this.name,
    required this.image,
    required this.price,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;

  void _addToCart() async {
    final cartItem = CartItem(
      name: widget.name,
      image: widget.image,
      price: widget.price,
      quantity: quantity,
    );

    try {
      // Get existing cart items
      String cartJson = await SharedPrefHelper.getString('cart_items');
      List<dynamic> cartList = [];

      if (cartJson.isNotEmpty) {
        cartList = json.decode(cartJson);
      }

      // Add new item
      cartList.add(cartItem.toJson());

      // Save updated cart
      await SharedPrefHelper.setData('cart_items', json.encode(cartList));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم إضافة ${widget.name} إلى السلة'),
            backgroundColor: ColorsManager.primary,
            duration: const Duration(seconds: 2),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CartPage(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء إضافة المنتج للسلة'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _buyNow() async {
    final cartItem = CartItem(
      name: widget.name,
      image: widget.image,
      price: widget.price,
      quantity: quantity,
    );

    try {
      // Save single item for checkout
      List<Map<String, dynamic>> cartList = [cartItem.toJson()];
      await SharedPrefHelper.setData('cart_items', json.encode(cartList));

      // Calculate and save total
      double total =
          double.parse(widget.price.replaceAll(RegExp(r'[^0-9.]'), '')) *
              quantity;
      await SharedPrefHelper.setData('cart_total', total);

      if (mounted) {
        // Check if user has a saved address
        final savedAddress = await SharedPrefHelper.getString('user_address');

        if (savedAddress == null || savedAddress.isEmpty) {
          // Show message about selecting address
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('يجب تحديد عنوان التوصيل أولاً'),
              backgroundColor: ColorsManager.primary,
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'حسناً',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );

          // Navigate to map page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MapScreen(),
            ),
          );
        } else {
          // If address exists, go directly to checkout
          Navigator.pushNamed(context, PageRouteNames.checkout);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء إضافة المنتج للسلة'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productPrice =
        double.parse(widget.price.replaceAll(RegExp(r'[^0-9.]'), ''));

    return Scaffold(
      backgroundColor: ColorsManager.moreLightGray,
      appBar: AppBar(
        title: Text(
          widget.name,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: ColorsManager.textDark,
          ),
        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),
        backgroundColor: ColorsManager.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorsManager.primary,
            size: 24.w,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            height: 1.h,
            color: ColorsManager.lightGray.withOpacity(0.5),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Container(
                    width: double.infinity,
                    height: 300.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: ColorsManager.primary.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            widget.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.image,
                              size: 100.sp,
                              color: Colors.grey,
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: ColorsManager.primary,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                '${widget.price} جنيه',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(begin: const Offset(0.9, 0.9)),

                  SizedBox(height: 24.h),

                  // Product Name
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),

                  SizedBox(height: 16.h),

                  // Price
                  Row(
                    children: [
                      Text(
                        '${widget.price} ج.م',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 300.ms)
                          .scale(begin: const Offset(0.8, 0.8)),
                      SizedBox(width: 8.w),
                      Text(
                        '${(productPrice * 1.2).toStringAsFixed(0)} ج.م',
                        style: TextStyle(
                          fontSize: 18.sp,
                          decoration: TextDecoration.lineThrough,
                          color: ColorsManager.gray,
                        ),
                      ).animate().fadeIn(delay: 400.ms),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Quantity Selector
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: ColorsManager.primary.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          'الكمية:',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorsManager.lightGray),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: quantity > 1
                                    ? () => setState(() => quantity--)
                                    : null,
                                icon: const Icon(Icons.remove),
                                constraints: BoxConstraints(
                                  minWidth: 40.w,
                                  minHeight: 40.h,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Text(
                                  '$quantity',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => setState(() => quantity++),
                                icon: const Icon(Icons.add),
                                constraints: BoxConstraints(
                                  minWidth: 40.w,
                                  minHeight: 40.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),

                  SizedBox(height: 32.h),

                  // Product Description
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: ColorsManager.primary.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'وصف المنتج',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'هذا منتج عالي الجودة يتميز بالمتانة والأداء الممتاز. مناسب للاستخدام اليومي ويأتي بضمان شامل.',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: ColorsManager.gray,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
                ],
              ),
            ),
          ),

          // Bottom Action Buttons
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, -2.h),
                ),
              ],
            ),
            child: Column(
              children: [
                // Total Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'المجموع:',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${(productPrice * quantity).toStringAsFixed(0)} ج.م',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 700.ms),

                SizedBox(height: 16.h),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _addToCart,
                        icon: const Icon(Icons.shopping_cart_outlined),
                        label: const Text('إضافة للسلة'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          side: const BorderSide(
                              color: ColorsManager.primary, width: 2),
                          foregroundColor: ColorsManager.primary,
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 800.ms).slideX(begin: -0.2),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _buyNow,
                        icon: const Icon(Icons.payment),
                        label: const Text('اشتري الآن'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ).animate().fadeIn(delay: 900.ms).slideX(begin: 0.2),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
