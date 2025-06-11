import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../../core/utils/color_manger.dart';
import '../../../../../../core/widgets/app_text_button.dart';

class ClinicErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ClinicErrorWidget({
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
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: ColorsManager.errorWithOpacity(0.1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ColorsManager.errorWithOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 70.sp,
              color: ColorsManager.error,
            ),
          ),
          SizedBox(height: 30.h),
          Text(
            'Error: $message',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: ColorsManager.error,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 30.h),
          AppTextButton(
            buttonText: 'Retry',
            onPressed: onRetry,
            leadingIcon: Icon(
              Icons.refresh_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
            backgroundColor: ColorsManager.error,
            buttonHeight: 50.h,
            horizontalPadding: 30.w,
            verticalPadding: 15.h,
            borderRadius: 16.r,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
        );
  }
}
