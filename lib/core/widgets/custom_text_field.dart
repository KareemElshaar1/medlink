import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_text_style.dart';
import '../utils/color_manger.dart';

class AppTextFormField extends StatefulWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? errorBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final String hintText;
  final String? labelText;
  final bool isObscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppTextFormField({
    super.key,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.errorBorder,
    this.inputTextStyle,
    this.hintStyle,
    this.labelStyle,
    required this.hintText,
    this.labelText,
    this.isObscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.backgroundColor,
    this.controller,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
  });

  @override
  _AppTextFormFieldState createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isObscureText ? !isPasswordVisible : false,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        focusedBorder:
        widget.focusedBorder ?? _buildBorder(ColorsManager.mainBlue),
        enabledBorder:
        widget.enabledBorder ?? _buildBorder(Color(0xff1565C0)),
        errorBorder: widget.errorBorder ?? _buildBorder(Colors.red),
        focusedErrorBorder: _buildBorder(Colors.red),
        hintStyle: widget.hintStyle ??
            TextStyles.font14GrayRegular.copyWith(fontSize: 14.sp),
        hintText: widget.hintText,
        labelText: widget.labelText,
        labelStyle: widget.labelStyle ??
            TextStyles.font14GrayRegular.copyWith(
              fontSize: 16.sp,
              color: ColorsManager.mainBlue,
            ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isObscureText
            ? IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
            size: 20.sp,
          ),
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
        )
            : widget.suffixIcon,
        fillColor: widget.backgroundColor ?? ColorsManager.moreLightGray,
        filled: true,
      ),
      style: widget.inputTextStyle ??
          TextStyles.font24BlackBold.copyWith(fontSize: 14.sp),
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
    );
  }

  /// Helper method to build borders for InputDecoration
  OutlineInputBorder _buildBorder(Color borderColor) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: borderColor,
        width: 1.4.w,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }
}