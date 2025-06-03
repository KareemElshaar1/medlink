import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../cubit/payment_cubit.dart';
import '../../domain/entities/payment.dart';

class PaymentPage extends StatefulWidget {
  final int appointmentId;

  const PaymentPage({
    super.key,
    required this.appointmentId,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderNameController = TextEditingController();
  final _expirationMonthController = TextEditingController();
  final _expirationYearController = TextEditingController();
  final _cvvController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardNumberController.dispose();
    _cardHolderNameController.dispose();
    _expirationMonthController.dispose();
    _expirationYearController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Payment Error",
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionBuilder: (context, animation1, animation2, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(
            CurvedAnimation(
              parent: animation1,
              curve: Curves.elasticOut,
            ),
          ),
          child: FadeTransition(
            opacity: animation1,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/animations/payment_error.json',
                      height: 200.h,
                      repeat: false,
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Payment Failed',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: 16.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Payment Success",
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionBuilder: (context, animation1, animation2, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(
            CurvedAnimation(
              parent: animation1,
              curve: Curves.elasticOut,
            ),
          ),
          child: FadeTransition(
            opacity: animation1,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/animations/payment_success.json',
                      height: 200.h,
                      repeat: false,
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Payment Successful',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Your payment has been processed successfully.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                        Navigator.of(context)
                            .pop(true); // Return to previous screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: 16.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isProcessing = true);
      final payment = Payment(
        appointmentId: widget.appointmentId,
        cardNumber: _cardNumberController.text,
        cardHolderName: _cardHolderNameController.text,
        expirationMonth: _expirationMonthController.text,
        expirationYear: _expirationYearController.text,
        cvv: _cvvController.text,
      );

      context.read<PaymentCubit>().processPayment(payment);
    }
  }

  Widget _buildAnimatedFormField({
    required Widget child,
    required int index,
  }) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF3B82F6),
              const Color(0xFF2563EB),
              Colors.white,
            ],
            stops: const [0.0, 0.3, 0.6],
          ),
        ),
        child: SafeArea(
          child: BlocListener<PaymentCubit, PaymentState>(
            listener: (context, state) {
              setState(() => _isProcessing = false);
              if (state is PaymentSuccess) {
                _showSuccessDialog();
              } else if (state is PaymentError) {
                _showErrorDialog(state.message);
              }
            },
            child: BlocBuilder<PaymentCubit, PaymentState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 20.h),
                        Text(
                          'Payment Details',
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Enter your card information to proceed',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 40.h),
                        _buildAnimatedFormField(
                          index: 0,
                          child: Container(
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _cardNumberController,
                                  decoration: InputDecoration(
                                    labelText: 'Card Number',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    prefixIcon: const Icon(Icons.credit_card),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter card number';
                                    }
                                    if (value.length != 16) {
                                      return 'Card number must be 16 digits';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16.h),
                                TextFormField(
                                  controller: _cardHolderNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Card Holder Name',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    prefixIcon: const Icon(Icons.person),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter card holder name';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _expirationMonthController,
                                        decoration: InputDecoration(
                                          labelText: 'Month (MM)',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                          ),
                                          prefixIcon:
                                              const Icon(Icons.calendar_today),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Required';
                                          }
                                          final month = int.tryParse(value);
                                          if (month == null ||
                                              month < 1 ||
                                              month > 12) {
                                            return 'Invalid month';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _expirationYearController,
                                        decoration: InputDecoration(
                                          labelText: 'Year (YYYY)',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                          ),
                                          prefixIcon:
                                              const Icon(Icons.calendar_month),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Required';
                                          }
                                          if (value.length != 4) {
                                            return 'Invalid year';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                TextFormField(
                                  controller: _cvvController,
                                  decoration: InputDecoration(
                                    labelText: 'CVV',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    prefixIcon: const Icon(Icons.security),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter CVV';
                                    }
                                    if (value.length != 3) {
                                      return 'CVV must be 3 digits';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 40.h),
                        _buildAnimatedFormField(
                          index: 1,
                          child: ElevatedButton(
                            onPressed: _isProcessing ? null : _processPayment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF3B82F6),
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              elevation: 4,
                            ),
                            child: _isProcessing
                                ? SizedBox(
                                    width: 24.w,
                                    height: 24.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFF3B82F6)),
                                    ),
                                  )
                                : Text(
                                    'Process Payment',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
