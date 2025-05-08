import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../../core/routes/page_routes_name.dart';
import '../../../../../../core/widgets/app_text_button.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/constants/clinic_constants.dart';
import '../../data/models/clinic_model.dart';
import '../cubit/clinic_cubit.dart';
import '../cubit/clinic_state.dart';
import '../widgets/clinic_error_widget.dart';
import '../widgets/clinic_empty_widget.dart';
import '../widgets/clinic_info_row.dart';
import 'clinic_management_page.dart';

class ClinicListPage extends StatefulWidget {
  const ClinicListPage({super.key});

  @override
  State<ClinicListPage> createState() => _ClinicListPageState();
}

class _ClinicListPageState extends State<ClinicListPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Color palette
  final Color _primaryColor = AppColors.primaryColor;
  final Color _secondaryColor = AppColors.secondaryColor;
  final Color _accentColor = AppColors.accentColor;
  final Color _backgroundColor = AppColors.backgroundColor;
  final Color _textColor = AppColors.textColor;
  final Color _errorColor = AppColors.errorColor;
  final Color _successColor = AppColors.successColor;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    context.read<ClinicCubit>().getClinics();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          ClinicStrings.appBarTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: ClinicDimensions.titleFontSize.sp,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(ClinicDimensions.cardBorderRadius),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              size: ClinicDimensions.smallIconSize.sp),
          onPressed: () {
            Navigator.pushReplacementNamed(context, PageRouteNames.doctorhome);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              size: ClinicDimensions.iconSize.sp,
            ),
            onPressed: () => _navigateToClinicManagement(),
            tooltip: ClinicStrings.addClinicButton,
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _backgroundColor,
              _secondaryColor.withOpacity(0.1),
            ],
          ),
        ),
        child: BlocBuilder<ClinicCubit, ClinicState>(
          builder: (context, state) {
            if (state is ClinicLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primaryColor),
                    SizedBox(height: 16.h),
                    Text(
                      'Loading clinics...',
                      style: TextStyle(
                        color: _textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ClinicError) {
              return _buildErrorState(context, state.message);
            } else if (state is ClinicsLoaded) {
              if (state.clinics.isEmpty) {
                return _buildEmptyState(context);
              }

              return RefreshIndicator(
                color: AppColors.primaryColor,
                backgroundColor: Colors.white,
                onRefresh: () async {
                  context.read<ClinicCubit>().getClinics();
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(16.r),
                  itemCount: state.clinics.length,
                  itemBuilder: (context, index) {
                    final clinic = state.clinics[index];
                    return _buildClinicCard(context, clinic)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: (100 * index).ms)
                        .slideX(begin: 0.2, end: 0);
                  },
                ),
              );
            }

            return _buildEmptyState(context);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToClinicManagement,
        tooltip: 'Add New Clinic',
        icon: Icon(
          Icons.add_rounded,
          size: 24.sp,
        ),
        label: Text(
          'Add Clinic',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      )
          .animate()
          .scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1, 1),
            duration: 600.ms,
          )
          .fadeIn(duration: 400.ms),
    );
  }

  void _navigateToClinicManagement() {
    final clinicCubit = context.read<ClinicCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => clinicCubit,
          child: const ClinicManagementPage(),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return ClinicErrorWidget(
      message: message,
      onRetry: () => context.read<ClinicCubit>().getClinics(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return ClinicEmptyWidget(
      onAddClinic: _navigateToClinicManagement,
    );
  }

  Widget _buildClinicCard(BuildContext context, ClinicModel clinic) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_hospital_rounded,
                    color: AppColors.primaryColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    clinic.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: _errorColor,
                    size: 24.sp,
                  ),
                  onPressed: () =>
                      _showDeleteConfirmationDialog(context, clinic),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _buildInfoRow(
              Icons.location_on_rounded,
              clinic.location,
            ),
            SizedBox(height: 8.h),
            _buildInfoRow(
              Icons.phone_rounded,
              clinic.phone,
            ),
            SizedBox(height: 8.h),
            _buildInfoRow(
              Icons.attach_money_rounded,
              '${clinic.price} EGP',
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status:',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: _textColor.withOpacity(0.7),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: _successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Active',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: _successColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, ClinicModel clinic) {
    final clinicCubit = context.read<ClinicCubit>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Clinic',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: _textColor,
          ),
        ),
        content: Text(
          'Are you sure you want to delete ${clinic.name}?',
          style: TextStyle(
            fontSize: 14.sp,
            color: _textColor,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: _textColor,
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              clinicCubit.deleteClinic(clinic.id!);
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: _errorColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return ClinicInfoRow(
      icon: icon,
      text: text,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
