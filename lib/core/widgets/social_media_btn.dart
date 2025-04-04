import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SocialMediaButtons extends StatelessWidget {
  const SocialMediaButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton('assets/images/google.png', 'Google', context),
        Gap(15.w),
        _buildSocialButton('assets/images/facebook.jpeg', 'Facebook', context),
        Gap(15.w),
        _buildSocialButton('assets/images/linkedin.jpeg', 'LinkedIn', context),
      ],
    );
  }

  Widget _buildSocialButton(
      String assetPath,
      String platform,
      BuildContext context,
      ) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: () {
          debugPrint("$platform button clicked");
        },
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: 90.w,
          height: 45.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          padding: EdgeInsets.all(8.w),
          child: Image.asset(assetPath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}