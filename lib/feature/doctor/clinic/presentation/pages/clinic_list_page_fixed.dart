import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../../core/routes/page_routes_name.dart';
import '../../../../../../core/widgets/app_text_button.dart';
import '../../domain/models/clinic_model.dart';
import '../cubit/clinic_cubit.dart';
import '../cubit/clinic_state.dart';
import 'clinic_management_page.dart';

class ClinicListPage extends StatefulWidget {
  const ClinicListPage({super.key});

  @override
  State<ClinicListPage> createState() => _ClinicListPageState();
}

class _ClinicListPageState extends State<ClinicListPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Enhanced color palette
  final Color _primaryColor = const Color(0xFF2196F3);
  final Color _secondaryColor = const Color(0xFF64B5F6);
  final Color _accentColor = const Color(0xFF1976D2);
  final Color _backgroundColor = const Color(0xFFF5F9FF);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF2C3E50);
  final Color _errorColor = const Color(0xFFE74C3C);
  final Color _successColor = const Color(0xFF2ECC71);

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
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          'My Clinics',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
          ),
        ),
        elevation: 0,
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.r),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, size: 20.sp),
          onPressed: () {
            Navigator.pushReplacementNamed(context, PageRouteNames.doctorhome);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              size: 28.sp,
            ),
            onPressed: () => _navigateToClinicManagement(),
            tooltip: 'Add New Clinic',
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
                    CircularProgressIndicator(color: _primaryColor),
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
                color: _primaryColor,
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
        backgroundColor: _primaryColor,
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => GetIt.I<ClinicCubit>(),
          child: const ClinicManagementPage(),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: _errorColor.withOpacity(0.1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _errorColor.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 70.sp,
              color: _errorColor,
            ),
          ),
          SizedBox(height: 30.h),
          Text(
            'Error: $message',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: _errorColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 30.h),
          AppTextButton(
            buttonText: 'Retry',
            onPressed: () {
              context.read<ClinicCubit>().getClinics();
            },
            leadingIcon: Icon(
              Icons.refresh_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
            backgroundColor: _errorColor,
            buttonHeight: 50.h,
            horizontalPadding: 30.w,
            verticalPadding: 15.h,
            borderRadius: 16.r,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
        );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryColor, _accentColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              Icons.local_hospital_rounded,
              size: 88.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 32.h),
          Text(
            'No Clinics Added Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              'Tap the + button to add your first clinic and start managing your practice',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _textColor.withOpacity(0.7),
                    height: 1.5,
                  ),
            ),
          ),
          SizedBox(height: 40.h),
          AppTextButton(
            buttonText: 'Add Your First Clinic',
            onPressed: _navigateToClinicManagement,
            leadingIcon: Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
            backgroundColor: _primaryColor,
            buttonHeight: 56.h,
            horizontalPadding: 32.w,
            verticalPadding: 16.h,
            borderRadius: 16.r,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
        );
  }

  Widget _buildClinicCard(BuildContext context, ClinicModel clinic) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            _cardColor,
            _backgroundColor,
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.15),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Navigate to clinic details
            },
            splashColor: _primaryColor.withOpacity(0.1),
            highlightColor: _primaryColor.withOpacity(0.05),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(14.r),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _primaryColor,
                              _accentColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                          boxShadow: [
                            BoxShadow(
                              color: _primaryColor.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.local_hospital_rounded,
                          color: Colors.white,
                          size: 28.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              clinic.name,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: _textColor,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: _primaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: _primaryColor.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                clinic.location,
                                style: TextStyle(
                                  color: _primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: _primaryColor,
                          size: 24.sp,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 3,
                        onSelected: (value) {
                          // Handle menu actions
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit_rounded,
                                  color: _primaryColor,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Edit',
                                  style: TextStyle(
                                    color: _primaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_rounded,
                                  color: _errorColor,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: _errorColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16.h),
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          _primaryColor.withOpacity(0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  _buildInfoRow(
                    context,
                    Icons.phone_rounded,
                    'Phone',
                    clinic.phone,
                  ),
                  SizedBox(height: 12.h),
                  _buildInfoRow(
                    context,
                    Icons.attach_money_rounded,
                    'Price',
                    '${clinic.price} EGP',
                  ),
                  SizedBox(height: 12.h),
                  _buildInfoRow(
                    context,
                    Icons.location_on_rounded,
                    'Location',
                    clinic.location,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            size: 16.sp,
            color: _primaryColor,
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          '$label: ',
          style: TextStyle(
            color: _textColor.withOpacity(0.7),
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: _textColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
