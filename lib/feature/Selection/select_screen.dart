import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medlink/core/utils/color_manger.dart';

import '../../core/routes/page_routes_name.dart';

class SelectScreen extends StatelessWidget {
  const SelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorsManager.primary.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 40.h),
              FadeInDown(
                duration: const Duration(milliseconds: 800),
                child: Text(
                  'Welcome to MedLink',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primary,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              FadeInDown(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 200),
                child: Text(
                  'Choose your role to continue',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(height: 60.h),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: FadeInLeft(
                          duration: const Duration(milliseconds: 800),
                          delay: const Duration(milliseconds: 400),
                          child: SelectionCard(
                            title: 'Doctor',
                            subtitle: 'Manage your clinics and appointments',
                            icon: Icons.medical_services_rounded,
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(PageRouteNames.sign_in_doctor);
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: FadeInRight(
                          duration: const Duration(milliseconds: 800),
                          delay: const Duration(milliseconds: 400),
                          child: SelectionCard(
                            title: 'Patient',
                            subtitle:
                                'Book appointments and manage your health',
                            icon: Icons.person_rounded,
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(PageRouteNames.sign_in_patient);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const SelectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50.sp,
              color: ColorsManager.primary,
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: ColorsManager.primary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
