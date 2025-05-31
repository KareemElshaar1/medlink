import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:medlink/core/theme/app_colors.dart';
import 'package:medlink/feature/doctor/profile/data/models/doctor_profile_model.dart';

class DrawerHeaderWidget extends StatelessWidget {
  final bool isLoading;
  final DoctorProfileModel? doctorProfile;

  const DrawerHeaderWidget({
    super.key,
    required this.isLoading,
    this.doctorProfile,
  });

  @override
  Widget build(BuildContext context) {
    final String fullName = isLoading
        ? 'Loading...'
        : doctorProfile != null
            ? '${doctorProfile!.firstName} ${doctorProfile!.lastName}'
            : 'Not Available';

    final String profilePicUrl = doctorProfile?.profilePic != null
        ? 'http://medlink.runasp.net${doctorProfile!.profilePic}'
        : '';

    return Container(
      height: 220.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 45.r,
                backgroundColor: Colors.white,
                child: isLoading
                    ? CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 3,
                      )
                    : profilePicUrl.isNotEmpty
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: profilePicUrl,
                              fit: BoxFit.cover,
                              width: 90.r,
                              height: 90.r,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 3,
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.person_rounded,
                                size: 50.sp,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.person_rounded,
                            size: 50.sp,
                            color: AppColors.primary,
                          ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              fullName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
