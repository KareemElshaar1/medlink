import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../../core/theme/app_colors.dart';

class ScheduleEmptyWidget extends StatelessWidget {
  final VoidCallback onAddSchedule;

  const ScheduleEmptyWidget({
    super.key,
    required this.onAddSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Animate(
            effects: [
              ScaleEffect(duration: 600.ms),
              ShakeEffect(duration: 600.ms),
            ],
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.secondary.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                Icons.calendar_today,
                size: 64.w,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No schedules yet',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.8),
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),
          SizedBox(height: 12.h),
          Text(
            'Add your first schedule to get started',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black.withOpacity(0.6),
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideY(begin: 0.2),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: onAddSchedule,
            icon: Icon(
              Icons.add_rounded,
              size: 24.sp,
              color: Colors.white,
            ),
            label: Text(
              'Add Your First Schedule',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(
                horizontal: 32.w,
                vertical: 16.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 400.ms).scale(),
        ],
      ),
    );
  }
}
