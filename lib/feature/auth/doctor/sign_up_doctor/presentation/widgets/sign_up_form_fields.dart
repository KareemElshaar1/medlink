import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/widgets/custom_text_field.dart';
 import '../manager/controller/sign_up_doctor_controller.dart';
import '../pages/sign_up_screen.dart';

class SignUpFormFields extends StatelessWidget {
  final SignUpDoctorController controller;
  final double verticalSpacing;

  const SignUpFormFields({
    super.key,
    required this.controller,
    required this.verticalSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First Name Field
          AppTextFormField(
            labelText: "First Name",
            controller: controller.firstNameController,
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
            controller: controller.lastNameController,
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
            controller: controller.emailController,
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
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return "Please enter a valid email";
              }
              return null;
            },
          ),
          Gap(verticalSpacing),

          // Password Field
          PasswordField(
            label: "Password",
            controller: controller.passwordController,
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
            controller: controller.confirmPasswordController,
            hintText: "Re-enter your password",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please confirm your password";
              }
              if (value != controller.passwordController.text) {
                return "Passwords don't match";
              }
              return null;
            },
          ),
          Gap(verticalSpacing),

          // Phone Number Field
          PhoneInputField(
            onPhoneChanged: controller.onPhoneChanged,
          ),
        ],
      ),
    );
  }
}