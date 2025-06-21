import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:medlink/core/utils/color_manger.dart';

class FakeVisaPaymentScreen extends StatefulWidget {
  const FakeVisaPaymentScreen({super.key});

  @override
  State<FakeVisaPaymentScreen> createState() => _FakeVisaPaymentScreenState();
}

class _FakeVisaPaymentScreenState extends State<FakeVisaPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // Luhn algorithm for card number validation
  bool _isValidCardNumber(String input) {
    String number = input.replaceAll(' ', '');
    if (number.length != 16) return false;
    int sum = 0;
    for (int i = 0; i < number.length; i++) {
      int digit = int.parse(number[number.length - 1 - i]);
      if (i % 2 == 1) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
    }
    return sum % 10 == 0;
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }
    String digits = value.replaceAll(' ', '');
    if (digits.length != 16) {
      return 'Card number must be 16 digits';
    }
    if (!_isValidCardNumber(value)) {
      return 'Invalid card number';
    }
    return null;
  }

  String? _validateExpiry(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }
    if (!RegExp(r'^\d{2}/\d{2}').hasMatch(value)) {
      return 'Use MM/YY format';
    }
    final parts = value.split('/');
    final month = int.tryParse(parts[0]) ?? 0;
    final year = int.tryParse(parts[1]) ?? 0;
    if (month < 1 || month > 12) {
      return 'Invalid month';
    }
    final now = DateTime.now();
    final fourDigitYear = 2000 + year;
    final expiry = DateTime(fourDigitYear, month + 1, 0);
    if (expiry.isBefore(DateTime(now.year, now.month))) {
      return 'Card expired';
    }
    return null;
  }

  String? _validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }
    if (!RegExp(r'^\d{3,4}').hasMatch(value)) {
      return 'CVV must be 3 or 4 digits';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (!RegExp(r'^[A-Za-z ]{3,}$').hasMatch(value)) {
      return 'Name must be at least 3 letters and only contain letters and spaces';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => Scaffold(
        backgroundColor: ColorsManager.background,
        appBar: AppBar(
          title: const Text("Visa Payment"),
          centerTitle: true,
          backgroundColor: ColorsManager.primary,
          foregroundColor: ColorsManager.background,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Form(
            key: _formKey,
            child: FadeInUp(
              duration: const Duration(milliseconds: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Visa_Inc._logo.svg/2560px-Visa_Inc._logo.svg.png',
                      width: 100.w,
                      height: 50.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Gap(30.h),
                  _buildTextField(
                    "Card Number",
                    "XXXX XXXX XXXX XXXX",
                    controller: _cardNumberController,
                    validator: _validateCardNumber,
                    maxLength: 19,
                    onChanged: (value) {
                      String digits = value.replaceAll(RegExp(r'[^\d]'), '');
                      String formatted = '';
                      for (int i = 0; i < digits.length; i++) {
                        if (i != 0 && i % 4 == 0) formatted += ' ';
                        formatted += digits[i];
                      }
                      if (formatted != value) {
                        _cardNumberController.text = formatted;
                        _cardNumberController.selection =
                            TextSelection.fromPosition(
                          TextPosition(offset: formatted.length),
                        );
                      }
                    },
                  ),
                  Gap(20.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          "Expiry Date",
                          "MM/YY",
                          controller: _expiryController,
                          validator: _validateExpiry,
                          maxLength: 5,
                          onChanged: (value) {
                            if (value.length == 2 && !value.contains('/')) {
                              _expiryController.text = '$value/';
                              _expiryController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: _expiryController.text.length),
                              );
                            }
                          },
                        ),
                      ),
                      Gap(15.w),
                      Expanded(
                        child: _buildTextField(
                          "CVV",
                          "123",
                          controller: _cvvController,
                          validator: _validateCVV,
                          isPassword: true,
                          maxLength: 4,
                        ),
                      ),
                    ],
                  ),
                  Gap(20.h),
                  _buildTextField(
                    "Cardholder Name",
                    "John Doe",
                    controller: _nameController,
                    validator: _validateName,
                    keyboardType: TextInputType.name,
                  ),
                  Gap(40.h),
                  FadeIn(
                    delay: const Duration(milliseconds: 500),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55.h,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // simulate payment
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Success"),
                                content: const Text(
                                    "Payment processed successfully."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK"),
                                  )
                                ],
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: const Text(
                          "Pay Now",
                          style: TextStyle(
                              fontSize: 18, color: ColorsManager.background),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
    bool isPassword = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
    int? maxLength,
    Function(String)? onChanged,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: ColorsManager.textDark),
        ),
        Gap(8.h),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType ?? TextInputType.number,
          validator: validator,
          maxLength: maxLength,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: ColorsManager.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: ColorsManager.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: ColorsManager.error),
            ),
            errorStyle: TextStyle(
              color: ColorsManager.error,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }
}
