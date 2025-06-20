import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/utils/color_manger.dart';

class ClinicInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ClinicInfoRow({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: ColorsManager.primary,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorsManager.textDark,
            ),
          ),
        ),
      ],
    );
  }
}
