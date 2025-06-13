import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:convert';
import '../../../core/utils/color_manger.dart';
import '../../../core/helper/shared_pref_helper.dart';
import '../../../core/routes/page_routes_name.dart';
import '../domain/models/cart_item.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];
  double total = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    try {
      String cartJson = await SharedPrefHelper.getString('cart_items');
      List<dynamic> cartList = [];

      if (cartJson.isNotEmpty) {
        cartList = json.decode(cartJson);
      }

      if (mounted) {
        setState(() {
          cartItems = cartList.map((item) => CartItem.fromJson(item)).toList();
          total = cartItems.fold(
              0,
              (sum, item) =>
                  sum +
                  (double.parse(item.price.replaceAll(RegExp(r'[^0-9.]'), '')) *
                      item.quantity));
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          cartItems = [];
          total = 0;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateQuantity(int index, int newQuantity) async {
    if (newQuantity < 1) return;

    setState(() {
      cartItems[index].quantity = newQuantity;
      total = cartItems.fold(
          0,
          (sum, item) =>
              sum +
              (double.parse(item.price.replaceAll(RegExp(r'[^0-9.]'), '')) *
                  item.quantity));
    });

    // Save updated cart
    List<Map<String, dynamic>> cartJson =
        cartItems.map((item) => item.toJson()).toList();
    await SharedPrefHelper.setData('cart_items', json.encode(cartJson));
  }

  Future<void> _deleteItem(int index) async {
    final deletedItem = cartItems[index];

    setState(() {
      cartItems.removeAt(index);
      total = cartItems.fold(
          0,
          (sum, item) =>
              sum +
              (double.parse(item.price.replaceAll(RegExp(r'[^0-9.]'), '')) *
                  item.quantity));
    });

    List<Map<String, dynamic>> cartJson =
        cartItems.map((item) => item.toJson()).toList();
    await SharedPrefHelper.setData('cart_items', json.encode(cartJson));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم حذف المنتج من السلة'),
          backgroundColor: ColorsManager.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          action: SnackBarAction(
            label: 'تراجع',
            textColor: ColorsManager.background,
            onPressed: () async {
              setState(() {
                cartItems.insert(index, deletedItem);
                total = cartItems.fold(
                    0,
                    (sum, item) =>
                        sum +
                        (double.parse(
                                item.price.replaceAll(RegExp(r'[^0-9.]'), '')) *
                            item.quantity));
              });

              List<Map<String, dynamic>> cartJson =
                  cartItems.map((item) => item.toJson()).toList();
              await SharedPrefHelper.setData(
                  'cart_items', json.encode(cartJson));
            },
          ),
        ),
      );
    }
  }

  Future<void> _deleteAllItems() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorsManager.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'تأكيد الحذف',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: ColorsManager.textDark,
            ),
          ),
          content: Text(
            'هل أنت متأكد من حذف جميع المنتجات من السلة؟',
            style: TextStyle(
              fontSize: 16.sp,
              color: ColorsManager.textMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  color: ColorsManager.primary,
                  fontSize: 16.sp,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'حذف الكل',
                style: TextStyle(
                  color: ColorsManager.error,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        cartItems.clear();
        total = 0;
      });

      await SharedPrefHelper.setData('cart_items', json.encode([]));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تم حذف جميع المنتجات من السلة'),
            backgroundColor: ColorsManager.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            action: SnackBarAction(
              label: 'تراجع',
              textColor: ColorsManager.background,
              onPressed: () async {
                await _loadCartItems();
              },
            ),
          ),
        );
      }
    }
  }

  void _checkout() async {
    await SharedPrefHelper.setData('cart_total', total);
    if (!mounted) return;
    Navigator.pushNamed(context, PageRouteNames.checkout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.background,
      appBar: AppBar(
        backgroundColor: ColorsManager.background,
        elevation: 0,
        title: Text(
          'سلة المشتريات',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: ColorsManager.textDark,
          ),
        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.delete_sweep,
                color: ColorsManager.error,
                size: 24.w,
              ),
              onPressed: _deleteAllItems,
              tooltip: 'حذف الكل',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: ColorsManager.primary,
              ),
            )
          : cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 80.w,
                        color: ColorsManager.gray,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'السلة فارغة',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorsManager.textDark,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'أضف بعض المنتجات إلى سلة المشتريات',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: ColorsManager.textMedium,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(16.w),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 16.h),
                            decoration: BoxDecoration(
                              color: ColorsManager.background,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: const [
                                BoxShadow(
                                  color: ColorsManager.shadow,
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Dismissible(
                              key: ValueKey(item.name + index.toString()),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: ColorsManager.background,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.r),
                                      ),
                                      title: Text(
                                        'تأكيد الحذف',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: ColorsManager.textDark,
                                        ),
                                      ),
                                      content: Text(
                                        'هل أنت متأكد من حذف هذا المنتج؟',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: ColorsManager.textMedium,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text(
                                            'إلغاء',
                                            style: TextStyle(
                                              color: ColorsManager.primary,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: Text(
                                            'حذف',
                                            style: TextStyle(
                                              color: ColorsManager.error,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20.w),
                                decoration: BoxDecoration(
                                  color: ColorsManager.error,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Icon(
                                  Icons.delete,
                                  color: ColorsManager.background,
                                  size: 24.w,
                                ),
                              ),
                              onDismissed: (direction) {
                                _deleteItem(index);
                              },
                              child: Container(
                                padding: EdgeInsets.all(16.w),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 80.w,
                                      height: 80.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        image: DecorationImage(
                                          image: NetworkImage(item.image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              color: ColorsManager.textDark,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            '${item.price} ج.م',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: ColorsManager.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.remove_circle_outline,
                                            color: ColorsManager.primary,
                                            size: 24.w,
                                          ),
                                          onPressed: () => _updateQuantity(
                                              index, item.quantity - 1),
                                        ),
                                        Text(
                                          '${item.quantity}',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                            color: ColorsManager.textDark,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.add_circle_outline,
                                            color: ColorsManager.primary,
                                            size: 24.w,
                                          ),
                                          onPressed: () => _updateQuantity(
                                              index, item.quantity + 1),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(delay: (200 * index).ms)
                              .slideX(begin: -0.2);
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: const BoxDecoration(
                        color: ColorsManager.background,
                        boxShadow: [
                          BoxShadow(
                            color: ColorsManager.shadow,
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'المجموع:',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsManager.textDark,
                                ),
                              ),
                              Text(
                                '${total.toStringAsFixed(2)} ج.م',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsManager.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: cartItems.isEmpty ? null : _checkout,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsManager.primary,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'الدفع',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsManager.background,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
