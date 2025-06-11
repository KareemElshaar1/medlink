import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color_manger.dart';
import 'font_weight_helper.dart';

class TextStyles {
  static TextStyle customStyle({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: color ?? ColorsManager.primary,
    );
  }

  static TextStyle font24BlackBold = customStyle(
    fontSize: 24,
    fontWeight: FontWeightHelper.bold,
    color: Colors.black,
  );

  static TextStyle font30BlueBold = customStyle(
    fontSize: 30,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.primary,
  );

  static TextStyle font13BlueSemiBold = customStyle(
    fontSize: 13,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.primary,
  );

  static TextStyle font13DarkBlueMedium = customStyle(
    fontSize: 13,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.primaryDark,
  );

  static TextStyle font14GrayRegular = customStyle(
    fontSize: 14,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.gray,
  );

  static TextStyle font16WhiteSemiBold = customStyle(
    fontSize: 16,
    fontWeight: FontWeightHelper.semiBold,
    color: Colors.white,
  );

  static TextStyle font18DarkBlueBold = customStyle(
    fontSize: 18,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.primaryDark,
  );

  static TextStyle font18WhiteMedium = customStyle(
    fontSize: 18,
    fontWeight: FontWeightHelper.medium,
    color: Colors.white,
  );
}
