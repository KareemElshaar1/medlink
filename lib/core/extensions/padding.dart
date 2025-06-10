import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension PaddingtoWidget on Widget {
  Widget setHorizontalPadding(BuildContext context, double value,
      {bool enableScreenUtil = true}) {
    double horizontalPadding = enableScreenUtil
        ? value.w
        : value;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: this,
    );
  }

  Widget setVerticalPadding(BuildContext context, double value,
      {bool enableScreenUtil = true}) {
    double verticalPadding = enableScreenUtil
        ? value.h
        : value;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: this,
    );
  }

  Widget setHorizontalAndVerticalPadding(
      BuildContext context, double widthValue, double heightValue,
      {bool enableScreenUtil = true}) {
    double horizontalPadding = enableScreenUtil
        ? widthValue.w
        : widthValue;
    double verticalPadding = enableScreenUtil
        ? heightValue.h
        : heightValue;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: this,
    );
  }

  Widget setOnlyPadding(
      BuildContext context, double top, double down, double right, double left,
      {bool enableScreenUtil = true}) {
    double topPadding = enableScreenUtil ? top.h : top;
    double bottomPadding = enableScreenUtil ? down.h : down;
    double rightPadding = enableScreenUtil ? right.w : right;
    double leftPadding = enableScreenUtil ? left.w : left;

    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        bottom: bottomPadding,
        right: rightPadding,
        left: leftPadding,
      ),
      child: this,
    );
  }
}