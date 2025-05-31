import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/app_text_button.dart';

class ScheduleErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ScheduleErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.error.withOpacity(0.1),
                  AppColors.warning.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 70.sp,
              color: AppColors.error,
            ),
          ).animate().fadeIn(duration: 600.ms).scale(),
          SizedBox(height: 24.h),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.8),
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideY(begin: 0.2),
          SizedBox(height: 12.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black.withOpacity(0.6),
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 400.ms)
              .slideY(begin: 0.2),
          SizedBox(height: 24.h),
          AppTextButton(
            buttonText: 'Retry',
            onPressed: onRetry,
            leadingIcon: Icon(
              Icons.refresh_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
            backgroundColor: AppColors.error,
            buttonHeight: 50.h,
            horizontalPadding: 30.w,
            verticalPadding: 15.h,
            borderRadius: 16.r,
          ).animate().fadeIn(duration: 600.ms, delay: 600.ms).scale(),
        ],
      ),
    );
  }
}
