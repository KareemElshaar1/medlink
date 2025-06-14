import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../routes/page_routes_name.dart';
import '../utils/color_manger.dart';

class RememberMeAndForgetPassword extends StatelessWidget {
  final bool? isRememberMeSelected;
  final Function(bool?) onRememberMeChanged;
  //final bool isDoctor;
  final VoidCallback? onForgetPasswordTap;

  const RememberMeAndForgetPassword({
    super.key,
    required this.isRememberMeSelected,
    required this.onRememberMeChanged,
    // required this.isDoctor,
    this.onForgetPasswordTap,
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
                activeColor: ColorsManager.primary,
                checkColor: Colors.white,
              ),
            ),
            Text(
              'Remember Me',
              style: TextStyle(fontSize: 14.sp, color: ColorsManager.textLight),
            ),
          ],
        ),
        // Forget Password
        GestureDetector(
          onTap: onForgetPasswordTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: ColorsManager.error, width: 1.0),
              ),
            ),
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorsManager.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
