import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../../core/routes/page_routes_name.dart';
import '../../../../../../core/widgets/app_text_button.dart';
import '../../../../../../core/utils/color_manger.dart';
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

class _ClinicListPageState extends State<ClinicListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ClinicCubit>().getClinics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'My Clinics',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
          ),
        ),
        elevation: 0,
        backgroundColor: ColorsManager.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.r),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, size: 20.sp),
          onPressed: () => Navigator.pushReplacementNamed(
              context, PageRouteNames.doctorhome),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, size: 22.sp),
            onPressed: () => context.read<ClinicCubit>().getClinics(),
          ),
        ],
      ),
      body: BlocConsumer<ClinicCubit, ClinicState>(
        listenWhen: (previous, current) =>
            current is ClinicError || current is ClinicSuccess,
        listener: (context, state) {
          if (state is ClinicError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ColorsManager.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is ClinicSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Clinic deleted successfully'),
                backgroundColor: ColorsManager.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        buildWhen: (previous, current) =>
            current is ClinicLoading ||
            current is ClinicError ||
            current is ClinicsLoaded,
        builder: (context, state) {
          if (state is ClinicLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: ColorsManager.primary,
              ),
            );
          }

          if (state is ClinicError) {
            return ClinicErrorWidget(
              message: state.message,
              onRetry: () => context.read<ClinicCubit>().getClinics(),
            );
          }

          if (state is ClinicsLoaded) {
            if (state.clinics.isEmpty) {
              return ClinicEmptyWidget(
                onAddClinic: _navigateToClinicManagement,
              );
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      '${state.clinics.length} Clinics',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final clinic = state.clinics[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _buildClinicCard(context, clinic)
                              .animate()
                              .fadeIn(duration: 400.ms, delay: (100 * index).ms)
                              .slideX(begin: 0.2, end: 0),
                        );
                      },
                      childCount: state.clinics.length,
                    ),
                  ),
                ),
              ],
            );
          }

          return ClinicEmptyWidget(
            onAddClinic: _navigateToClinicManagement,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToClinicManagement,
        backgroundColor: ColorsManager.primary,
        child: Icon(
          Icons.add_rounded,
          size: 24.sp,
          color: Colors.white,
        ),
      ),
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

  Widget _buildClinicCard(BuildContext context, ClinicModel clinic) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () => _navigateToClinicManagement(),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with clinic name and actions
                Row(
                  children: [
                    // Clinic icon and name
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: ColorsManager.primary,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.local_hospital_rounded,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  clinic.name,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1A1A1A),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                Text(
                                  'Medical Clinic',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Action buttons
                    Row(
                      children: [
                        _buildActionButton(
                          icon: Icons.edit_rounded,
                          color: ColorsManager.primary,
                          onPressed: () => _navigateToClinicManagement(),
                        ),
                        SizedBox(width: 4.w),
                        _buildActionButton(
                          icon: Icons.delete_outline_rounded,
                          color: ColorsManager.error,
                          onPressed: () =>
                              _showDeleteConfirmationDialog(context, clinic),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // Clinic information
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.08),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Phone and Price row
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoItem(
                              icon: Icons.phone_rounded,
                              label: 'Phone',
                              value: clinic.phone,
                              iconColor: const Color(0xFF4A90E2),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40.h,
                            color: Colors.grey.withOpacity(0.2),
                            margin: EdgeInsets.symmetric(horizontal: 16.w),
                          ),
                          Expanded(
                            child: _buildInfoItem(
                              icon: Icons.attach_money_rounded,
                              label: 'Price',
                              value: '${clinic.price} EGP',
                              iconColor: const Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // Location information
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.08),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.location_on_rounded,
                          size: 16.sp,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              clinic.location,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF1A1A1A),
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            color: color,
            size: 18.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: iconColor,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF1A1A1A),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, ClinicModel clinic) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ClinicCubit>(),
        child: BlocBuilder<ClinicCubit, ClinicState>(
          builder: (context, state) {
            return AlertDialog(
              title: Text(
                'Delete Clinic',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: Text(
                'Are you sure you want to delete this clinic?',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: state is ClinicLoading
                      ? null
                      : () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: state is ClinicLoading
                      ? null
                      : () {
                          Navigator.pop(context);
                          context.read<ClinicCubit>().deleteClinic(clinic.id!);
                        },
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      color: ColorsManager.error,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
