import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: Colors.grey[400], thickness: 1, endIndent: 8.w),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            "Or continue with",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: Colors.grey[400], thickness: 1, indent: 8.w),
        ),
      ],
    );
  }
}