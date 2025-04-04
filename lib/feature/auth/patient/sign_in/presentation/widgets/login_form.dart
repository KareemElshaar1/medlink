import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:medlink/core/extensions/padding.dart';

import '../../../../../../core/routes/page_routes_name.dart';
import '../../../../../../core/widgets/Remember_Me_And_ForgetPassword.dart';
import '../../../../../../core/widgets/divider.dart';
import '../../../../../../core/widgets/login_btn.dart';
import '../../../../../../core/widgets/login_title.dart';
import '../../../../../../core/widgets/sign_up_link.dart';
import '../../../../../../core/widgets/social_media_btn.dart';
import 'form_field.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isObscureText;
  final bool? isRememberMeSelected;
  final bool isLoading;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function(bool) onObscureTextChanged;
  final Function(bool?) onRememberMeChanged;
  final VoidCallback onLoginPressed;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.isObscureText,
    required this.isRememberMeSelected,
    required this.isLoading,
    required this.emailController,
    required this.passwordController,
    required this.onObscureTextChanged,
    required this.onRememberMeChanged,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Login Title with Animation
            LoginTitle(),
          Gap(20.h),

          // Form Fields
          FormFields(
            isObscureText: isObscureText,
            emailController: emailController,
            passwordController: passwordController,
            onObscureTextChanged: onObscureTextChanged,
          ),
          Gap(15.h),

          // Remember Me and Forget Password
          RememberMeAndForgetPassword(
            isRememberMeSelected: isRememberMeSelected,
            onRememberMeChanged: onRememberMeChanged,
          ),
          Gap(20.h),

          // Login Button
          LoginButton(isLoading: isLoading, onPressed: onLoginPressed),
          Gap(30.h),

          // OR Divider
          const OrDivider(),
          Gap(20.h),

          // Social Media Buttons
          const SocialMediaButtons(),
          Gap(20.h),

          // Sign Up Link
          CustomSignUpLink(
            onTap: () {
              Navigator.of(context).pushNamed(PageRouteNames.sign_up_patient);
            },
          ),
        ],
      ).setHorizontalPadding(context, enableScreenUtil: true, 18),
    );
  }
}