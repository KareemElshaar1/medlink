import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_strings.dart';
import '../utils/color_manger.dart';
import 'app_text_button.dart';


class LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const LoginButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.mainBlue.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: AppTextButton(
        buttonText: isLoading ? "Logging in..." : AppStrings.loginNow,
        buttonHeight: 50.h,
        buttonWidth: double.infinity,
        backgroundColor: ColorsManager.mainBlue,
        onPressed: isLoading ? null : onPressed,
        disabledBackgroundColor: ColorsManager.lighterGray,
        isLoading: isLoading,
      ),
    );
  }
}