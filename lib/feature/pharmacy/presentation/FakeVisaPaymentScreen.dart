import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:animate_do/animate_do.dart';

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

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }
    if (value.replaceAll(' ', '').length != 16) {
      return 'Card number must be 16 digits';
    }
    return null;
  }

  String? _validateExpiry(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
      return 'Use MM/YY format';
    }
    final parts = value.split('/');
    final month = int.parse(parts[0]);
    if (month < 1 || month > 12) {
      return 'Invalid month';
    }
    return null;
  }

  String? _validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }
    if (value.length != 3) {
      return 'CVV must be 3 digits';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 3) {
      return 'Name is too short';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text("Visa Payment"),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
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
                      if (value.length == 4 ||
                          value.length == 9 ||
                          value.length == 14) {
                        _cardNumberController.text = '$value ';
                        _cardNumberController.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                              offset: _cardNumberController.text.length),
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
                          maxLength: 3,
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
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: const Text(
                          "Pay Now",
                          style: TextStyle(fontSize: 18, color: Colors.white),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
        ),
        Gap(8.h),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: TextInputType.number,
          validator: validator,
          maxLength: maxLength,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
            errorStyle: TextStyle(
              color: Colors.red,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }
}
