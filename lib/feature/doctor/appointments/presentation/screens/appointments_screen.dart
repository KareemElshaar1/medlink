import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../di.dart';
import '../cubit/appointment_cubit.dart';
import 'package:intl/intl.dart';
import '../../../../../core/utils/color_manger.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AppointmentCubit>()..getAppointments(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120.h,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'My Appointments',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.textDark,
                  ),
                ),
                titlePadding: EdgeInsets.only(left: 20.w, bottom: 16.h),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(20.h),
                child: Container(
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<AppointmentCubit, AppointmentState>(
                builder: (context, state) {
                  if (state is AppointmentLoading) {
                    return _buildLoadingView();
                  } else if (state is AppointmentLoaded) {
                    return _buildAppointmentsList(state.appointments);
                  } else if (state is AppointmentError) {
                    return _buildErrorView(state.message);
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return SizedBox(
      height: 400.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(ColorsManager.primary),
              strokeWidth: 3,
            ),
            SizedBox(height: 16.h),
            Text(
              'Loading appointments...',
              style: TextStyle(
                fontSize: 16.sp,
                color: ColorsManager.gray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(String message) {
    if (message.contains('404') || message.contains('Not Found')) {
      return SizedBox(
        height: 400.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_alt_rounded,
                size: 64.sp,
                color: ColorsManager.gray.withOpacity(0.5),
              ),
              SizedBox(height: 24.h),
              Text(
                'No Patients Yet',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorsManager.textDark,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Your patients will appear here once they book appointments',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ColorsManager.gray,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 400.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48.sp,
              color: ColorsManager.error,
            ),
            SizedBox(height: 16.h),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: ColorsManager.textDark,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorsManager.gray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsList(List appointments) {
    if (appointments.isEmpty) {
      return _buildEmptyView();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Upcoming', appointments.length),
          SizedBox(height: 16.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: appointments.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return _buildAppointmentCard(appointment, index);
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return SizedBox(
      height: 400.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64.sp,
              color: ColorsManager.gray.withOpacity(0.5),
            ),
            SizedBox(height: 24.h),
            Text(
              'No appointments yet',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: ColorsManager.textDark,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your upcoming appointments will appear here',
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorsManager.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: ColorsManager.textDark,
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: ColorsManager.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: ColorsManager.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentCard(dynamic appointment, int index) {
    final colors = [
      ColorsManager.primary,
      ColorsManager.secondary,
      // Colors.blue[300]!,
      // Colors.blue[400]!,
      // Colors.blue[500]!,
      // Colors.blue[600]!,
    ];

    final cardColor = colors[index % colors.length];
    final isToday = _isToday(appointment.day);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cardColor.withOpacity(0.1),
            cardColor.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: cardColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          if (isToday)
            Positioned(
              top: 16.h,
              right: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'TODAY',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [cardColor, cardColor.withOpacity(0.7)],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.patient,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorsManager.textDark,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Patient Consultation',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: ColorsManager.gray,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                _buildInfoRow(
                  Icons.location_on_rounded,
                  appointment.clinic,
                  cardColor,
                ),
                SizedBox(height: 12.h),
                _buildInfoRow(
                  Icons.calendar_today_rounded,
                  DateFormat('EEEE, MMM dd, yyyy').format(
                    DateTime.parse(appointment.day),
                  ),
                  cardColor,
                ),
                SizedBox(height: 12.h),
                _buildInfoRow(
                  Icons.access_time_rounded,
                  '${appointment.appointmentStart} - ${appointment.appointmentEnd}',
                  cardColor,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Container(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 16.sp,
            color: color,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorsManager.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  bool _isToday(String dateString) {
    final appointmentDate = DateTime.parse(dateString);
    final today = DateTime.now();
    return appointmentDate.year == today.year &&
        appointmentDate.month == today.month &&
        appointmentDate.day == today.day;
  }
}
