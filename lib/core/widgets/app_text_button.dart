import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/color_manger.dart';

class AppTextButton extends StatefulWidget {
  final double? borderRadius;
  final List<Color>? gradientColors; // Gradient colors
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? buttonWidth;
  final double? buttonHeight;
  final String buttonText;
  final TextStyle? textStyle;
  final TextStyle? disabledTextStyle;
  final VoidCallback?
      onPressed; // Changed to VoidCallback to match how it's used in LoginButton
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool showLoading; // Parameter to control loading visibility
  final bool useGradient; // Flag to determine if gradient is applied
  final bool isLoading; // External loading state

  const AppTextButton({
    super.key,
    this.borderRadius,
    this.gradientColors,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.horizontalPadding,
    this.verticalPadding,
    this.buttonHeight,
    this.buttonWidth,
    required this.buttonText,
    this.textStyle,
    this.disabledTextStyle,
    this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.showLoading = true,
    this.useGradient = true,
    this.isLoading = false,
  });

  @override
  State<AppTextButton> createState() => _AppTextButtonState();
}

class _AppTextButtonState extends State<AppTextButton> {
  bool _internalLoading = false;

  Future<void> _handlePress() async {
    if (widget.onPressed != null && !_internalLoading && !widget.isLoading) {
      if (widget.showLoading) {
        setState(() {
          _internalLoading = true;
        });
      }
      try {
        widget.onPressed!();
      } finally {
        if (widget.showLoading && mounted) {
          setState(() {
            _internalLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = widget.onPressed == null;
    final bool isShowingLoading =
        (widget.isLoading || _internalLoading) && widget.showLoading;

    return SizedBox(
      width: widget.buttonWidth?.w ?? double.infinity,
      height: widget.buttonHeight?.h ?? 50.h,
      child: GestureDetector(
        onTap: isButtonDisabled || isShowingLoading ? null : _handlePress,
        child: Container(
          decoration: BoxDecoration(
            gradient: widget.useGradient && !isButtonDisabled
                ? LinearGradient(
                    colors: widget.gradientColors ??
                        [
                          ColorsManager.primaryLight,
                          ColorsManager.primary,
                          ColorsManager.primaryDark,
                        ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isButtonDisabled
                ? widget.disabledBackgroundColor ?? ColorsManager.disabled
                : widget.useGradient
                    ? null
                    : widget.backgroundColor ?? ColorsManager.primary,
            borderRadius: BorderRadius.circular(widget.borderRadius?.r ?? 16.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding?.w ?? 12.w,
            vertical: widget.verticalPadding?.h ?? 14.h,
          ),
          child: Center(
            child: isShowingLoading
                ? CircularProgressIndicator(
                    color: ColorsManager.background,
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.leadingIcon != null) ...[
                        widget.leadingIcon!,
                        SizedBox(width: 8.w),
                      ],
                      Text(
                        widget.buttonText,
                        style: isButtonDisabled
                            ? (widget.disabledTextStyle ??
                                TextStyle(
                                  fontSize: 16.sp,
                                  color: ColorsManager.textDisabled,
                                  fontWeight: FontWeight.w600,
                                ))
                            : (widget.textStyle ??
                                TextStyle(
                                  fontSize: 16.sp,
                                  color: ColorsManager.background,
                                  fontWeight: FontWeight.w600,
                                )),
                      ),
                      if (widget.trailingIcon != null) ...[
                        SizedBox(width: 8.w),
                        widget.trailingIcon!,
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
