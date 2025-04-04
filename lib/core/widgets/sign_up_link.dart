import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/color_manger.dart';

class CustomSignUpLink extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onTap;

  const CustomSignUpLink({
    super.key,
    this.text = "Don't have an account? ",
    this.actionText = "Sign Up",
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: TextStyle(fontSize: 14.sp, color: Colors.grey[700])),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorsManager.mainBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
