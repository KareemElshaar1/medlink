import 'dart:ui';

import '../../../core/utils/app_strings.dart';
import '../../../core/utils/image_manger.dart';

/// Represents information for each onboarding screen.
class OnboardingInfo {
  final String title;
  final String description;
  final String image;
  final Color backgroundColor;

  const OnboardingInfo({required this.title, required this.description, required this.image, required this.backgroundColor});
}

List<OnboardingInfo> onboardingItems = [
  OnboardingInfo(title: AppStrings.title1, description: AppStrings.descriptions1, image: ImageManager.onboarding2, backgroundColor: Color(0xFF4FC3F7)),
  OnboardingInfo(title: AppStrings.title2, description: AppStrings.descriptions2, image: ImageManager.onboarding1, backgroundColor: Color(0xFF298DB9)),
  OnboardingInfo(title: AppStrings.title3, description: AppStrings.descriptions3, image: ImageManager.onboarding3, backgroundColor: Color(0xFF0C75A4)),
];