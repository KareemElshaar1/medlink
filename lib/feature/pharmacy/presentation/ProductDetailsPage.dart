import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
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
      String cartJson = await SharedPrefHelper.getString('cart_items');
      List<dynamic> cartList = [];

      if (cartJson.isNotEmpty) {
        cartList = json.decode(cartJson);
      }

      cartList.add(cartItem.toJson());

      await SharedPrefHelper.setData('cart_items', json.encode(cartList));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.name} added to cart'),
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
            content: Text('Error adding product to cart'),
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
      List<Map<String, dynamic>> cartList = [cartItem.toJson()];
      await SharedPrefHelper.setData('cart_items', json.encode(cartList));

      double total =
          double.parse(widget.price.replaceAll(RegExp(r'[^0-9.]'), '')) *
              quantity;
      await SharedPrefHelper.setData('cart_total', total);

      if (mounted) {
        final savedAddress = await SharedPrefHelper.getString('user_address');

        if (savedAddress == null || savedAddress.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Please select a delivery address first'),
              backgroundColor: ColorsManager.primary,
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MapScreen(),
            ),
          );
        } else {
          Navigator.pushNamed(context, PageRouteNames.checkout);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error adding product to cart'),
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
                                '${widget.price} EGP',
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
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Text(
                        '${widget.price} EGP',
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
                        '${(productPrice * 1.2).toStringAsFixed(0)} EGP',
                        style: TextStyle(
                          fontSize: 18.sp,
                          decoration: TextDecoration.lineThrough,
                          color: ColorsManager.gray,
                        ),
                      ).animate().fadeIn(delay: 400.ms),
                    ],
                  ),
                  SizedBox(height: 24.h),
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
                          'Quantity:',
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
                          'Product Description',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'This is a high-quality product known for its durability and excellent performance. Suitable for daily use and comes with a comprehensive warranty.',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${(productPrice * quantity).toStringAsFixed(0)} EGP',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 700.ms),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _addToCart,
                        icon: const Icon(Icons.shopping_cart_outlined),
                        label: const Text('Add to Cart'),
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
                        label: const Text('Buy Now'),
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
          Gap(16.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: ColorsManager.background,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: ColorsManager.border,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: ColorsManager.primary,
                      size: 24.w,
                    ),
                    Gap(8.w),
                    Text(
                      'Important Note',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorsManager.textDark,
                      ),
                    ),
                  ],
                ),
                Gap(8.h),
                Text(
                  'You must consult your doctor first before taking this treatment for your safety.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ColorsManager.textMedium,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Gap(24.h),
        ],
      ),
    );
  }
}
