import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../../core/widgets/input_label.dart';

class FormFields extends StatelessWidget {
  final bool isObscureText;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function(bool) onObscureTextChanged;

  const FormFields({
    super.key,
    required this.isObscureText,
    required this.emailController,
    required this.passwordController,
    required this.onObscureTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email Field
        const InputLabel(text: "Email"),
        SizedBox(
          height: 50.h,
          child: AppTextFormField(
            controller: emailController,
            hintText: 'Enter your email',
            prefixIcon: const Icon(Icons.email_outlined),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
        Gap(20.h),

        // Password Field
        const InputLabel(text: "Password"),
        SizedBox(
          height: 50.h,
          child: AppTextFormField(
            controller: passwordController,
            hintText: 'Enter your password',
            isObscureText: isObscureText,
            prefixIcon: const Icon(Icons.lock_outline),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            suffixIcon: GestureDetector(
              onTap: () {
                onObscureTextChanged(!isObscureText);
              },
              child: Icon(
                isObscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
            ),
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.visiblePassword,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
      ],
    );
  }
}
