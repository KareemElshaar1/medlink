import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../../core/utils/color_manger.dart';

class ScheduleLoadingWidget extends StatelessWidget {
  const ScheduleLoadingWidget({super.key});

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
                  ColorsManager.primary.withOpacity(0.1),
                  ColorsManager.secondary.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: CircularProgressIndicator(
              color: ColorsManager.primary,
              strokeWidth: 3,
            ),
          ).animate().fadeIn(duration: 600.ms).scale(),
          SizedBox(height: 24.h),
          Text(
            'Loading schedules...',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black.withOpacity(0.6),
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
        ],
      ),
    );
  }
}
