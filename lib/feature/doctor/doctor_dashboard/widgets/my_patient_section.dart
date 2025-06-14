import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medlink/core/utils/color_manger.dart';
import 'package:medlink/core/routes/page_routes_name.dart';
import 'package:medlink/feature/doctor/appointments/presentation/cubit/appointment_cubit.dart';
import 'package:medlink/feature/doctor/appointments/domain/entities/appointment.dart';

class MyPatientWidget extends StatelessWidget {
  const MyPatientWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AppointmentError) {
          return _buildErrorState();
        }

        if (state is AppointmentLoaded) {
          final appointments = state.appointments;

          if (appointments.isEmpty) {
            return _buildEmptyState();
          }

          // Filter today's appointments
          final todayAppointments = appointments.where((appointment) {
            final appointmentDate = DateTime.parse(appointment.day);
            final today = DateTime.now();
            return appointmentDate.year == today.year &&
                appointmentDate.month == today.month &&
                appointmentDate.day == today.day;
          }).toList();

          if (todayAppointments.isEmpty) {
            return _buildEmptyState();
          }

          // Take only first 2 appointments
          final recentAppointments = todayAppointments.take(2).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Patients',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorsManager.textDark,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, PageRouteNames.appointments);
                      },
                      icon: Icon(
                        Icons.arrow_forward_rounded,
                        size: 18.sp,
                        color: ColorsManager.primary,
                      ),
                      label: Text(
                        'See All',
                        style: TextStyle(
                          color: ColorsManager.primary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = recentAppointments[index];
                  return _buildAppointmentCard(appointment);
                },
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: ColorsManager.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                appointment.patient[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primary,
                ),
              ),
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
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorsManager.textDark,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${appointment.appointmentStart} - ${appointment.appointmentEnd}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorsManager.textLight,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  appointment.clinic,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorsManager.primary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: _getStatusColor('scheduled').withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'Scheduled',
              style: TextStyle(
                fontSize: 12.sp,
                color: _getStatusColor('scheduled'),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 48.sp,
            color: ColorsManager.textLight,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Appointments Today',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: ColorsManager.textDark,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'You don\'t have any appointments scheduled for today',
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorsManager.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48.sp,
            color: Colors.red,
          ),
          SizedBox(height: 16.h),
          Text(
            'Error Loading Appointments',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: ColorsManager.textDark,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please try again later',
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorsManager.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return ColorsManager.primary;
    }
  }
}
