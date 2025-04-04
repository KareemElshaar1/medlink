// lib/presentation/screens/sign_up_doctor.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:medlink/core/extensions/padding.dart';

import '../../../../../../core/widgets/app_text_button.dart';
import '../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../core/widgets/buildHeader.dart';
import '../../domain/entities/speciality_entity.dart';
import '../manager/doctor_registration_cubit.dart';
import '../manager/specialities/specialities_cubit.dart';

class SignUpDoctor extends StatefulWidget {
  const SignUpDoctor({super.key});

  @override
  State<SignUpDoctor> createState() => _SignUpDoctorState();
}

class _SignUpDoctorState extends State<SignUpDoctor> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? phoneNumber;
  Speciality? selectedSpeciality;

  @override
  void initState() {
    super.initState();
    context.read<SpecialitiesCubit>().getSpecialities();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      context.read<DoctorRegistrationCubit>().registerDoctor(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        phone: phoneNumber ?? "",
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
        specialityId: selectedSpeciality?.id ?? 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for more adaptive layouts
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    // Adjust padding based on screen size
    final horizontalPadding = isSmallScreen ? 16.0.w : 24.0.w;
    final verticalSpacing = isSmallScreen ? 16.h : 20.h;

    // Adjust header height based on screen size
    final headerHeight = isSmallScreen ? 180.0 : 220.0;

    return MultiBlocListener(
      listeners: [
        BlocListener<DoctorRegistrationCubit, DoctorRegistrationState>(
          listener: (context, state) {
            if (state is DoctorRegistrationLoading) {
              // Show loading indicator if needed
            } else if (state is DoctorRegistrationSuccess) {
              // Navigate to sign in page
              Navigator.pushNamed(context, '/sign_in_doctor');
            } else if (state is DoctorRegistrationError) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(16.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Animated Header - Adjusted height
                MedLinkHeader(height: headerHeight, showAnimation: true),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Gap(30.h),
                      // Title
                      const SignUpTitle(),
                      Gap(30.h),

                      // Form
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // First Name Field
                            AppTextFormField(
                              labelText: "First Name",
                              controller: firstNameController,
                              hintText: "Enter your first name",
                              prefixIcon: Icon(
                                Icons.person_rounded,
                                color: Colors.blue,
                                size: 20.sp,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your first name";
                                }
                                return null;
                              },
                            ),
                            Gap(verticalSpacing),

                            // Last Name Field
                            AppTextFormField(
                              labelText: "Last Name",
                              controller: lastNameController,
                              hintText: "Enter your last name",
                              prefixIcon: Icon(
                                Icons.person_rounded,
                                color: Colors.blue,
                                size: 20.sp,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your last name";
                                }
                                return null;
                              },
                            ),
                            Gap(verticalSpacing),

                            // Email Field
                            AppTextFormField(
                              labelText: "Email Address",
                              controller: emailController,
                              hintText: "doctor@example.com",
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icon(
                                Icons.email_rounded,
                                color: Colors.blue,
                                size: 20.sp,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your email";
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return "Please enter a valid email";
                                }
                                return null;
                              },
                            ),
                            Gap(verticalSpacing),

                            // Password Field
                            PasswordField(
                              label: "Password",
                              controller: passwordController,
                              hintText: "Enter your password",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a password";
                                }
                                if (value.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
                              },
                            ),
                            Gap(verticalSpacing),

                            // Confirm Password Field
                            PasswordField(
                              label: "Confirm Password",
                              controller: confirmPasswordController,
                              hintText: "Re-enter your password",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please confirm your password";
                                }
                                if (value != passwordController.text) {
                                  return "Passwords don't match";
                                }
                                return null;
                              },
                            ),
                            Gap(verticalSpacing),

                            // Phone Number Field
                            PhoneInputField(
                              onPhoneChanged: (phone) {
                                phoneNumber = phone;
                              },
                            ),
                            Gap(verticalSpacing),

                            // Speciality Dropdown
                            BlocBuilder<SpecialitiesCubit, SpecialitiesState>(
                              builder: (context, state) {
                                if (state is SpecialitiesLoading) {
                                  return _buildLoadingSpecialities();
                                } else if (state is SpecialitiesError) {
                                  return _buildErrorSpecialities(state.message);
                                } else if (state is SpecialitiesLoaded) {
                                  return _buildSpecialitiesDropdown(
                                    state.specialities,
                                  );
                                }

                                return _buildLoadingSpecialities();
                              },
                            ),
                            Gap(30.h),

                            // Sign Up Button
                            BlocBuilder<
                                DoctorRegistrationCubit,
                                DoctorRegistrationState
                            >(
                              builder: (context, state) {
                                final isLoading =
                                state is DoctorRegistrationLoading;

                                return AppTextButton(
                                  buttonText: "Sign Up",
                                  buttonHeight: 40.h,
                                  buttonWidth: double.infinity,
                                  onPressed: isLoading ? null : _handleSignUp,
                                  backgroundColor: Colors.blue,
                                  disabledBackgroundColor: Colors.grey,
                                  isLoading: isLoading,
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      Gap(30.h),

                      // Social Sign Up Section
                      const SignUpAlternatives(),

                      Gap(40.h), // Extra bottom space
                    ],
                  ).setHorizontalPadding(context, enableScreenUtil: true, horizontalPadding),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingSpecialities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Medical Speciality",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(8.h),
        Container(
          height: 56.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: SizedBox(
              height: 24.h,
              width: 24.w,
              child: CircularProgressIndicator(
                color: Colors.blue,
                strokeWidth: 2.5.w,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorSpecialities(String errorMessage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Medical Speciality",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
          ),
          child: Text(
            "Failed to load specialities",
            style: TextStyle(color: Colors.red, fontSize: 14.sp),
          ),
        ),
        Gap(8.h),
        TextButton.icon(
          onPressed: () {
            context.read<SpecialitiesCubit>().getSpecialities();
          },
          icon: Icon(Icons.refresh, size: 18.sp, color: Colors.blue),
          label: Text(
            "Retry",
            style: TextStyle(color: Colors.blue, fontSize: 14.sp),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            backgroundColor: Colors.blue.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialitiesDropdown(List<Speciality> specialities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Medical Speciality",
        //   style: TextStyle(
        //     color: Colors.blue,
        //     fontSize: 15.sp,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        // Gap(8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: DropdownButtonFormField<Speciality>(
            value: selectedSpeciality,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 16.h,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.blue, width: 1.5.w),
              ),
              prefixIcon: Icon(
                Icons.medical_services_rounded,
                color: Colors.blue,
                size: 20.sp,
              ),
            ),
            hint: Text(
              "Select your speciality",
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
            icon: Icon(Icons.arrow_drop_down, color: Colors.blue, size: 24.sp),
            isExpanded: true,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            items: specialities.map((speciality) {
              return DropdownMenuItem<Speciality>(
                value: speciality,
                child: Text(
                  speciality.name,
                  style: TextStyle(color: Colors.black87, fontSize: 14.sp),
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedSpeciality = newValue;
              });
            },
            validator: (value) {
              if (value == null) {
                return "Please select your speciality";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}

// Improved Password Field Widget
class PasswordField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  const PasswordField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.validator,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   widget.label,
        //   style: TextStyle(
        //     color: Colors.blue,
        //     fontSize: 15.sp,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        // Gap(8.h),
        AppTextFormField(
          controller: widget.controller,
          isObscureText: !isPasswordVisible,
          hintText: widget.hintText,
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
              size: 20.sp,
            ),
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
          ),
          prefixIcon: Icon(
            Icons.lock_rounded,
            color: Colors.blue,
            size: 20.sp,
          ),
          validator: widget.validator ?? (value) {
            if (value == null || value.isEmpty) {
              return 'Password cannot be empty';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
      ],
    );
  }
}

// Improved Sign Up Title Widget
class SignUpTitle extends StatelessWidget {
  const SignUpTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Sign Up as Doctor",
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            "Create your account to start providing healthcare services",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

// Improved Phone Input Field Widget
class PhoneInputField extends StatelessWidget {
  final Function(String) onPhoneChanged;

  const PhoneInputField({super.key, required this.onPhoneChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Phone Number",
        //   style: TextStyle(
        //     color: Colors.blue,
        //     fontSize: 15.sp,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        // Gap(8.h),
        AppTextFormField(
          onChanged: onPhoneChanged,
          keyboardType: TextInputType.phone,
          hintText: "Enter your phone number",
          prefixIcon: Icon(
            Icons.phone_rounded,
            color: Colors.blue,
            size: 20.sp,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your phone number";
            }
            // You could add phone validation logic here
            return null;
          },
        ),
      ],
    );
  }
}

// Improved Sign Up Alternatives Widget
class SignUpAlternatives extends StatelessWidget {
  const SignUpAlternatives({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive sizing for social buttons
    final buttonSize = MediaQuery.of(context).size.width < 360 ? 45.0 : 50.0;

    return Column(
      children: [
        // OR divider
        Row(
          children: [
            Expanded(
              child: Divider(color: Colors.grey.withOpacity(0.3), thickness: 1),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                "OR",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(color: Colors.grey.withOpacity(0.3), thickness: 1),
            ),
          ],
        ),
        Gap(20.h),

        // Social sign up options
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              onPressed: () {},
              icon: "assets/icons/google.png",
              backgroundColor: Colors.white,
              size: buttonSize,
            ),
            Gap(16.w),
            _buildSocialButton(
              onPressed: () {},
              icon: "assets/icons/facebook.png",
              backgroundColor: Colors.white,
              size: buttonSize,
            ),
            Gap(16.w),
            _buildSocialButton(
              onPressed: () {},
              icon: "assets/icons/apple.png",
              backgroundColor: Colors.white,
              size: buttonSize,
            ),
          ],
        ),
        Gap(24.h),

        // Already have an account
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account?",
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign_in_doctor');
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                "Sign In",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onPressed,
    required String icon,
    required Color backgroundColor,
    required double size,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: size.w,
        height: size.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
          // Add subtle shadow for better visual appeal
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            icon,
            width: size * 0.48,  // 24/50 = 0.48
            height: size * 0.48,
          ),
        ),
      ),
    );
  }
}