// lib/presentation/screens/sign_up_doctor.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:medlink/core/extensions/padding.dart';
import 'package:medlink/core/utils/color_manger.dart';
import 'package:medlink/core/widgets/buildHeader.dart' as header;

import '../../../../../../core/routes/page_routes_name.dart';
import '../../../../../../core/widgets/app_text_button.dart';
import '../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../patient/specilaity/domain/entities/speciality_entity.dart';
import '../../../../../patient/specilaity/manger/cubit/specialities_cubit.dart';
import '../manager/doctor_registration_cubit.dart';
import '../manager/controller/sign_up_doctor_controller.dart';

// Password Field Widget
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
        AppTextFormField(
          controller: widget.controller,
          isObscureText: !isPasswordVisible,
          hintText: widget.hintText,
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: ColorsManager.textLight,
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
            color: ColorsManager.primary,
            size: 20.sp,
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}

// Sign Up Title Widget
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
            color: ColorsManager.textDark,
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            "Create your account to start providing healthcare services",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: ColorsManager.textLight),
          ),
        ),
      ],
    );
  }
}

// Phone Input Field Widget
class PhoneInputField extends StatelessWidget {
  final Function(String) onPhoneChanged;

  const PhoneInputField({super.key, required this.onPhoneChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextFormField(
          onChanged: onPhoneChanged,
          keyboardType: TextInputType.phone,
          hintText: "Enter your phone number",
          prefixIcon: Icon(
            Icons.phone_rounded,
            color: ColorsManager.primary,
            size: 20.sp,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your phone number";
            }
            return null;
          },
        ),
      ],
    );
  }
}

class SignUpDoctor extends StatefulWidget {
  const SignUpDoctor({super.key});

  @override
  State<SignUpDoctor> createState() => _SignUpDoctorState();
}

class _SignUpDoctorState extends State<SignUpDoctor> {
  late final SignUpDoctorController _controller;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _controller = SignUpDoctorController();
    _controller.init(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showLoadingOverlay() {
    setState(() {
      _isNavigating = true;
    });
  }

  void _hideLoadingOverlay() {
    setState(() {
      _isNavigating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for more adaptive layouts
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    // Adjust padding based on screen size
    final horizontalPadding = isSmallScreen ? 16.0.w : 24.0.w;
    final verticalSpacing = isSmallScreen ? 16.h : 20.h;

    return BlocListener<DoctorRegistrationCubit, DoctorRegistrationState>(
      listener: (context, state) {
        if (state is DoctorRegistrationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const header.MedLinkHeader(
                        height: 220.0, showAnimation: true),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.r),
                          topRight: Radius.circular(30.r),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding, vertical: 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SignUpTitle(),
                          Gap(30.h),
                          Form(
                            key: _controller.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // First Name Field
                                AppTextFormField(
                                  labelText: "First Name",
                                  controller: _controller.firstNameController,
                                  hintText: "Enter your first name",
                                  prefixIcon: Icon(
                                    Icons.person_rounded,
                                    color: ColorsManager.primary,
                                    size: 20.sp,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your first name";
                                    }
                                    return null;
                                  },
                                ),
                                Gap(20.h),

                                // Last Name Field
                                AppTextFormField(
                                  labelText: "Last Name",
                                  controller: _controller.lastNameController,
                                  hintText: "Enter your last name",
                                  prefixIcon: Icon(
                                    Icons.person_rounded,
                                    color: ColorsManager.primary,
                                    size: 20.sp,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your last name";
                                    }
                                    return null;
                                  },
                                ),
                                Gap(20.h),

                                // Email Field
                                AppTextFormField(
                                  labelText: "Email Address",
                                  controller: _controller.emailController,
                                  hintText: "doctor@example.com",
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icon(
                                    Icons.email_rounded,
                                    color: ColorsManager.primary,
                                    size: 20.sp,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your email";
                                    }
                                    if (!RegExp(
                                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value)) {
                                      return "Please enter a valid email";
                                    }
                                    return null;
                                  },
                                ),
                                Gap(verticalSpacing),

                                // Password Field
                                PasswordField(
                                  label: "Password",
                                  controller: _controller.passwordController,
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
                                  controller:
                                      _controller.confirmPasswordController,
                                  hintText: "Re-enter your password",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please confirm your password";
                                    }
                                    if (value !=
                                        _controller.passwordController.text) {
                                      return "Passwords don't match";
                                    }
                                    return null;
                                  },
                                ),
                                Gap(verticalSpacing),

                                // Phone Number Field
                                PhoneInputField(
                                  onPhoneChanged: _controller.onPhoneChanged,
                                ),
                                Gap(verticalSpacing),

                                // Speciality Dropdown
                                BlocBuilder<SpecialitiesCubit,
                                    SpecialitiesState>(
                                  builder: (context, state) {
                                    if (state is SpecialitiesLoading) {
                                      return _buildLoadingSpecialities();
                                    } else if (state is SpecialitiesError) {
                                      return _buildErrorSpecialities(
                                          state.message);
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
                                BlocBuilder<DoctorRegistrationCubit,
                                    DoctorRegistrationState>(
                                  builder: (context, state) {
                                    final isLoading =
                                        state is DoctorRegistrationLoading;

                                    return AppTextButton(
                                      buttonText: "Sign Up",
                                      buttonHeight: 50.h,
                                      buttonWidth: double.infinity,
                                      onPressed: isLoading
                                          ? null
                                          : () async {
                                              if (_controller
                                                      .formKey.currentState
                                                      ?.validate() ??
                                                  false) {
                                                setState(() {
                                                  _isNavigating = true;
                                                });

                                                // Add a slight delay to show loading
                                                await Future.delayed(
                                                    const Duration(
                                                        milliseconds: 2000));

                                                if (mounted) {
                                                  setState(() {
                                                    _isNavigating = false;
                                                  });
                                                  _controller.handleSignUp();
                                                }
                                              }
                                            },
                                      backgroundColor: ColorsManager.primary,
                                      disabledBackgroundColor:
                                          ColorsManager.disabled,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isNavigating)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 40.w,
                        height: 40.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.w,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              ColorsManager.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingSpecialities() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorSpecialities(String message) {
    return Text(
      'Error loading specialities: $message',
      style: TextStyle(color: ColorsManager.textDark, fontSize: 14.sp),
    );
  }

  Widget _buildSpecialitiesDropdown(List<Speciality> specialities) {
    return DropdownButtonFormField<Speciality>(
      decoration: InputDecoration(
        labelText: "Speciality",
        hintText: "Select your medical speciality",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: ColorsManager.disabled),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide:
              const BorderSide(color: ColorsManager.disabled, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide:
              const BorderSide(color: ColorsManager.primary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(
          Icons.medical_services_rounded,
          color: ColorsManager.primary,
          size: 20.sp,
        ),
        suffixIcon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: ColorsManager.darkGray,
          size: 24.sp,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
      ),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      icon: const SizedBox.shrink(), // Hide default dropdown icon
      isExpanded: true,
      style: TextStyle(
        fontSize: 16.sp,
        color: ColorsManager.darkGray,
        fontWeight: FontWeight.w500,
      ),
      items: specialities.map((speciality) {
        return DropdownMenuItem<Speciality>(
          value: speciality,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              children: [
                Icon(
                  Icons.local_hospital_outlined,
                  size: 18.sp,
                  color: ColorsManager.primary.withOpacity(0.7),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    speciality.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: ColorsManager.darkGray,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
      onChanged: _controller.onSpecialityChanged,
      validator: (value) {
        if (value == null) {
          return "Please select your speciality";
        }
        return null;
      },
      menuMaxHeight: 300.h,
    );
  }
}
