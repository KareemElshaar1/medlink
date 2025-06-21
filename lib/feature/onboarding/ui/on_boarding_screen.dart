import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:medlink/feature/onboarding/ui/widgets/Dot_Indicator.dart';
import 'package:medlink/feature/onboarding/ui/widgets/Onboarding_Button.dart';
import 'package:medlink/feature/onboarding/ui/widgets/Onboarding_Page_Widget.dart';

import '../data/on_boarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingItems.length,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPageWidget(page: onboardingItems[index]);
            },
          ),
          Positioned(
            bottom: 50.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                DotIndicator(
                  currentPage: _currentPage,
                  totalPages: onboardingItems.length,
                ),
                Gap(30.h),
                OnboardingButton(
                  pageController: _pageController,
                  currentPage: _currentPage,
                  totalPages: onboardingItems.length,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
