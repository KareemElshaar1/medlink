import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medlink/feature/doctor/doctor_dashboard/models/drawer_item_model.dart';

class DrawerItemWidget extends StatelessWidget {
  final DrawerItem item;
  final bool isSelected;
  final bool isExpanded;
  final VoidCallback onTap;

  const DrawerItemWidget({
    super.key,
    required this.item,
    required this.isSelected,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.blueAccent.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(15.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                children: [
                  SizedBox(width: 16.w),
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? item.color.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.icon,
                      color: isSelected ? item.color : Colors.grey,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        color: isSelected ? item.color : Colors.black87,
                        fontSize: 16.sp,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (item.subItems != null)
                    Icon(
                      isExpanded
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      color: isSelected ? item.color : Colors.grey,
                    )
                  else if (isSelected)
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: item.color,
                      size: 16.sp,
                    ),
                  SizedBox(width: 16.w),
                ],
              ),
            ),
          ),
        ),
        if (isExpanded && item.subItems != null)
          ...item.subItems!.map((subItem) => Container(
                margin: EdgeInsets.only(left: 16.w),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: InkWell(
                  onTap: () {
                    // Handle sub-item navigation
                  },
                  borderRadius: BorderRadius.circular(15.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 16.w,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          subItem.icon,
                          color: Colors.grey,
                          size: 18.sp,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          subItem.title,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
      ],
    );
  }
}
