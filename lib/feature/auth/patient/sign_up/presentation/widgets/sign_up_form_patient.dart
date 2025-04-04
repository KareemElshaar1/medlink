import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';


import '../../../../../../core/widgets/app_text_button.dart';
import '../../../../../../core/widgets/custom_text_field.dart';
import '../../../../doctor/sign_up_doctor/presentation/pages/sign_up_screen.dart';
import '../manager/controller/sign_up_patient_controller.dart';
import '../manager/cubit/patient_register_cubit.dart';
import '../manager/cubit/patient_register_state.dart';

class SignUpForm extends StatelessWidget {
  final SignUpPatientViewModel viewModel;

  const SignUpForm({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: viewModel.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Name Field
          AppTextFormField(
            labelText: "Full Name",
            controller: viewModel.nameController,
            hintText: "Enter your full name",
            prefixIcon: const Icon(Icons.person_rounded, color: Colors.blue),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your name";
              }
              return null;
            },
          ),
          const Gap(20),

          // Birth Date Field
          _buildBirthDateField(context),
          const Gap(20),

          // Email Field
          AppTextFormField(
            labelText: "Email Address",
            controller: viewModel.emailController,
            hintText: "patient@example.com",
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_rounded, color: Colors.blue),
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
          const Gap(20),

          // Phone Number Field
          AppTextFormField(
            labelText: "Phone Number",
            controller: viewModel.phoneController,
            hintText: "Enter your phone number",
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone_rounded, color: Colors.blue),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your phone number";
              }
              return null;
            },
          ),
          const Gap(20),

          // Password Field
          PasswordField(
            label: "Password",
            controller: viewModel.passwordController,
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
          const Gap(20),

          // Confirm Password Field
          PasswordField(
            label: "Confirm Password",
            controller: viewModel.confirmPasswordController,
            hintText: "Re-enter your password",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please confirm your password";
              }
              if (value != viewModel.passwordController.text) {
                return "Passwords don't match";
              }
              return null;
            },
          ),
          const Gap(30),

          // Sign Up Button
          BlocBuilder<PatientRegistrationCubit, PatientRegistrationState>(
            builder: (context, state) {
              final isLoading = state is PatientRegistrationLoading;

              return AppTextButton(
                buttonText: "Sign Up",
                buttonHeight: 50.h,
                buttonWidth: double.infinity,
                onPressed:
                    isLoading ? null : () => viewModel.handleSignUp(context),
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
    );
  }

  Widget _buildBirthDateField(BuildContext context) {
    return AppTextFormField(
      labelText: "Birth Date",
      hintText: "Select Birth Date",
      readOnly: true,
      controller: TextEditingController(
        text:
            viewModel.selectedBirthDate != null
                ? "${viewModel.selectedBirthDate!.year}-${viewModel.selectedBirthDate!.month.toString().padLeft(2, '0')}-${viewModel.selectedBirthDate!.day.toString().padLeft(2, '0')}"
                : "",
      ),
      prefixIcon: const Icon(Icons.calendar_today_rounded, color: Colors.blue),
      onTap: () => viewModel.selectDate(context),
      validator: (value) {
        if (viewModel.selectedBirthDate == null) {
          return "Please select your birth date";
        }
        return null;
      },
    );
  }
}
