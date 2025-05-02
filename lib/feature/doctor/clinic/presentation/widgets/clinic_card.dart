import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/models/clinic_model.dart';
import '../constants/clinic_constants.dart';

class ClinicCard extends StatelessWidget {
  final ClinicModel clinic;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ClinicCard({
    super.key,
    required this.clinic,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ClinicColors.cardGradientStart,
            ClinicColors.cardGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(ClinicDimensions.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius:
              BorderRadius.circular(ClinicDimensions.cardBorderRadius),
          onTap: onEdit,
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 16.h),
                _buildInfoRow(
                  icon: Icons.phone,
                  label: ClinicStrings.phoneLabel,
                  value: clinic.phone,
                ),
                SizedBox(height: 8.h),
                _buildInfoRow(
                  icon: Icons.attach_money,
                  label: ClinicStrings.priceLabel,
                  value: '${clinic.price} EGP',
                ),
                SizedBox(height: 8.h),
                _buildInfoRow(
                  icon: Icons.location_on,
                  label: ClinicStrings.locationLabel,
                  value: clinic.location,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            clinic.name,
            style: TextStyle(
              fontSize: ClinicDimensions.cardTitleFontSize.sp,
              fontWeight: FontWeight.bold,
              color: ClinicColors.darkBlue,
            ),
          ),
        ),
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            color: ClinicColors.darkBlue,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ClinicDimensions.menuBorderRadius),
          ),
          elevation: ClinicDimensions.menuElevation,
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            } else if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: ClinicDimensions.menuIconSize),
                  SizedBox(width: 8.w),
                  Text(ClinicStrings.editAction),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: ClinicDimensions.menuIconSize),
                  SizedBox(width: 8.w),
                  Text(ClinicStrings.deleteAction),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: ClinicColors.iconBackground.withOpacity(0.1),
            borderRadius:
                BorderRadius.circular(ClinicDimensions.iconBorderRadius),
          ),
          child: Icon(
            icon,
            size: ClinicDimensions.smallIconSize.sp,
            color: ClinicColors.iconBackground,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: ClinicDimensions.smallFontSize.sp,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: ClinicDimensions.bodyFontSize.sp,
                  color: ClinicColors.darkBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
