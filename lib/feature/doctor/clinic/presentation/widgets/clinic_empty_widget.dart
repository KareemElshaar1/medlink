import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../../core/utils/color_manger.dart';

class ClinicEmptyWidget extends StatelessWidget {
  final VoidCallback onAddClinic;

  const ClinicEmptyWidget({
    super.key,
    required this.onAddClinic,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorsManager.primary, ColorsManager.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ColorsManager.primaryWithOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              Icons.local_hospital_rounded,
              size: 88.sp,
              color: ColorsManager.textDark,
            ),
          ),
          SizedBox(height: 32.h),
          Text(
            'No Clinics Added Yet',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: ColorsManager.textDark,
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              'Tap the + button to add your first clinic and start managing your practice',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: ColorsManager.textDark.withOpacity(0.7),
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 40.h),
          ElevatedButton.icon(
            onPressed: onAddClinic,
            icon: Icon(
              Icons.add_rounded,
              size: 24.sp,
              color: Colors.white,
            ),
            label: Text(
              'Add Your First Clinic',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.primary,
              padding: EdgeInsets.symmetric(
                horizontal: 32.w,
                vertical: 16.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
