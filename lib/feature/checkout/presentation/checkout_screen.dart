import 'package:flutter/material.dart';
import '../../../core/helper/shared_pref_helper.dart';
import '../../../core/routes/page_routes_name.dart';
import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import '../../pharmacy/presentation/FakeVisaPaymentScreen.dart';
import '../../../core/utils/color_manger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:gap/gap.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _savedAddress;
  double _total = 0.0;
  bool _isLoading = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeStripe();
    _loadSavedData();
  }

  Future<void> _initializeStripe() async {
    await stripe.Stripe.instance.applySettings();
  }

  Future<void> _loadSavedData() async {
    try {
      final savedAddress = await SharedPrefHelper.getString('user_address');
      final savedTotal = await SharedPrefHelper.getDouble('cart_total') ?? 0.0;

      if (!mounted) return;
      setState(() {
        _savedAddress = savedAddress;
        _total = savedTotal;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleLocationChange() {
    Navigator.pushNamed(context, PageRouteNames.map).then((_) {
      // Reload data when returning from map screen
      _loadSavedData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.background,
      appBar: AppBar(
        backgroundColor: ColorsManager.background,
        elevation: 0,
        title: Text(
          'تأكيد الطلب',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: ColorsManager.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: ColorsManager.primary,
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Section
                  FadeInDown(
                    duration: const Duration(milliseconds: 500),
                    child: _buildLocationCard(),
                  ),
                  Gap(16.h),

                  // Order Summary Section
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: _buildOrderSummary(),
                  ),
                  Gap(16.h),

                  // Payment Method Section
                  FadeInDown(
                    duration: const Duration(milliseconds: 700),
                    child: _buildPaymentMethods(),
                  ),
                  Gap(24.h),

                  // Confirm Order Button
                  FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    child: _buildConfirmButton(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLocationCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
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
                  Icons.location_on,
                  color: ColorsManager.primary,
                  size: 24.w,
                ),
                Gap(8.w),
                Text(
                  'عنوان التوصيل',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.textDark,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _handleLocationChange,
                  icon: Icon(
                    Icons.edit,
                    color: ColorsManager.primary,
                    size: 20.w,
                  ),
                  label: Text(
                    'تغيير',
                    style: TextStyle(
                      color: ColorsManager.primary,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
            Gap(8.h),
            Text(
              _savedAddress ?? 'لا يوجد عنوان محدد',
              style: TextStyle(
                fontSize: 16.sp,
                color: ColorsManager.textMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ملخص الطلب',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: ColorsManager.textDark,
          ),
        ),
        Gap(8.h),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
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
              children: [
                _buildOrderItem(
                  'تكلفة المنتجات',
                  '${_total.toStringAsFixed(2)} ج.م',
                ),
                const Divider(color: ColorsManager.border),
                _buildOrderItem(
                  'تكلفة التوصيل',
                  '20 ج.م',
                ),
                const Divider(color: ColorsManager.border),
                _buildOrderItem(
                  'المجموع',
                  '${(_total + 20).toStringAsFixed(2)} ج.م',
                  isTotal: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'طريقة الدفع',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: ColorsManager.textDark,
          ),
        ),
        Gap(8.h),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
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
              children: [
                _buildPaymentMethodItem(
                  'الدفع ببطاقة الائتمان',
                  Icons.credit_card,
                  isSelected: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FakeVisaPaymentScreen(),
                      ),
                    );
                  },
                ),
                const Divider(color: ColorsManager.border),
                _buildPaymentMethodItem(
                  'الدفع عند الاستلام',
                  Icons.money,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isProcessing
            ? null
            : _savedAddress == null || _savedAddress!.isEmpty
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('يجب تحديد عنوان التوصيل أولاً'),
                        backgroundColor: ColorsManager.error,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    );
                    _handleLocationChange();
                  }
                : _handleOrderConfirmation,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.primary,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
        child: _isProcessing
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: const CircularProgressIndicator(
                  color: ColorsManager.background,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'تأكيد الطلب',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.background,
                ),
              ),
      ),
    );
  }

  Widget _buildOrderItem(String title, String price, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 18.sp : 16.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color:
                  isTotal ? ColorsManager.textDark : ColorsManager.textMedium,
            ),
          ),
          const Spacer(),
          Text(
            price,
            style: TextStyle(
              fontSize: isTotal ? 18.sp : 16.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? ColorsManager.primary : ColorsManager.textMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodItem(
    String title,
    IconData icon, {
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? ColorsManager.primary : ColorsManager.gray,
              size: 24.w,
            ),
            Gap(8.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? ColorsManager.textDark
                    : ColorsManager.textMedium,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: ColorsManager.primary,
                size: 24.w,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleOrderConfirmation() async {
    setState(() => _isProcessing = true);

    try {
      // Clear cart after successful order
      await SharedPrefHelper.setData('cart_items', json.encode([]));
      await SharedPrefHelper.setData('cart_total', 0.0);

      if (!mounted) return;
      setState(() => _isProcessing = false);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم تأكيد الطلب بنجاح'),
          backgroundColor: ColorsManager.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );

      // Navigate back to home
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isProcessing = false);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('حدث خطأ أثناء تأكيد الطلب'),
          backgroundColor: ColorsManager.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
    }
  }
}
