import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../../core/routes/page_routes_name.dart';
import '../../../../../../../core/widgets/app_text_button.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../manager/doctor_registration_cubit.dart';

class ConfirmDoctorCodeScreen extends StatefulWidget {
  final String correctCode;
  final DoctorRegistrationCubit cubit;
  final Map<String, dynamic> registrationData;

  const ConfirmDoctorCodeScreen({
    super.key,
    required this.correctCode,
    required this.cubit,
    required this.registrationData,
  });

  @override
  State<ConfirmDoctorCodeScreen> createState() =>
      _ConfirmDoctorCodeScreenState();
}

class _ConfirmDoctorCodeScreenState extends State<ConfirmDoctorCodeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController codeController = TextEditingController();
  bool _isVerifying = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    codeController.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    if (codeController.text == widget.correctCode) {
      setState(() {
        _isVerifying = true;
      });

      try {
        await widget.cubit.registerDoctor(
          firstName: widget.registrationData['firstName'],
          lastName: widget.registrationData['lastName'],
          email: widget.registrationData['email'],
          phone: widget.registrationData['phone'],
          password: widget.registrationData['password'],
          confirmPassword: widget.registrationData['confirmPassword'],
          specialityId: widget.registrationData['specialityId'],
        );

        await widget.cubit.sendVerificationToken();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Registration Successful! Please sign in.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(
            PageRouteNames.sign_in_doctor,
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error during registration: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isVerifying = false;
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Incorrect Code!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.blue.shade700,
                        size: 24.sp,
                      ),
                    ),
                    Gap(20.h),

                    // Header Section
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.mark_email_read_rounded,
                            size: 80.sp,
                            color: Colors.blue.shade700,
                          ),
                          Gap(24.h),
                          Text(
                            "Verify Your Email",
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          Gap(12.h),
                          Text(
                            "We've sent a verification code to your email address",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Gap(40.h),

                    // Verification Code Input
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Enter Verification Code",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          Gap(16.h),
                          AppTextFormField(
                            controller: codeController,
                            keyboardType: TextInputType.number,
                            hintText: "Enter 6-digit code",
                            prefixIcon: Icon(
                              Icons.lock_outline_rounded,
                              color: Colors.blue.shade700,
                              size: 20.sp,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the verification code";
                              }
                              if (value.length != 6) {
                                return "Code must be 6 digits";
                              }
                              if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
                                return "Code must contain only numbers";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Gap(24.h),

                    // Verify Button
                    AppTextButton(
                      buttonText: "Verify Email",
                      buttonHeight: 56.h,
                      buttonWidth: double.infinity,
                      onPressed: _isVerifying ? null : _verifyCode,
                      backgroundColor: Colors.blue.shade700,
                      disabledBackgroundColor: Colors.grey.shade300,
                      isLoading: _isVerifying,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(16.h),

                    // Resend Code Option
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implement resend code functionality
                        },
                        child: Text(
                          "Didn't receive the code? Resend",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
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
      ),
    );
  }
}
