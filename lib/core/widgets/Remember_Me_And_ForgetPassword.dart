import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/color_manger.dart';

class RememberMeAndForgetPassword extends StatelessWidget {
  final bool? isRememberMeSelected;
  final Function(bool?) onRememberMeChanged;

  const RememberMeAndForgetPassword({
    super.key,
    required this.isRememberMeSelected,
    required this.onRememberMeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remember Me Checkbox
        Row(
          children: [
            Theme(
              data: ThemeData(
                checkboxTheme: CheckboxThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              child: Checkbox(
                value: isRememberMeSelected,
                onChanged: onRememberMeChanged,
                activeColor: ColorsManager.mainBlue,
                checkColor: Colors.white,
              ),
            ),
            Text(
              'Remember Me',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
            ),
          ],
        ),
        // Forget Password
        GestureDetector(
          onTap: () {
            // Handle forget password action
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: const Color(0xFFF81418), width: 1.0),
              ),
            ),
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFFF81418),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
