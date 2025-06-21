import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/shared_pref_helper.dart';
import '../../../../core/routes/page_routes_name.dart';
import '../../data/on_boarding_model.dart';

class OnboardingButton extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final int totalPages;

  const OnboardingButton({
    super.key,
    required this.pageController,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ElevatedButton(
        onPressed: () async {
          if (currentPage < totalPages - 1) {
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          } else {
            await SharedPrefHelper.setData("first_time", false);
            Navigator.of(context).pushNamed(PageRouteNames.SelectScreen);

            // Navigate to Home Screen
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: onboardingItems[currentPage].backgroundColor,
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          elevation: 5,
          minimumSize: Size(double.infinity, 56.h),
        ),
        child: Text(
          currentPage < totalPages - 1 ? 'Next' : 'Get Started',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
