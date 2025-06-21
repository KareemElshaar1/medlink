import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DotIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const DotIndicator(
      {super.key, required this.currentPage, required this.totalPages});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.only(right: 8.w),
          height: 10.h,
          width: currentPage == index ? 25.w : 10.w,
          decoration: BoxDecoration(
            color: currentPage == index
                ? Colors.white
                : Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(5.r),
          ),
        ),
      ),
    );
  }
}
