import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medlink/core/routes/page_routes_name.dart';
import 'package:medlink/core/utils/color_manger.dart';
import 'package:medlink/feature/doctor/appointments/presentation/cubit/appointment_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:medlink/feature/doctor/doctor_dashboard/widgets/stats_section_widget.dart';

class MyPatientsSectionWidget extends StatelessWidget {
  const MyPatientsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<AppointmentCubit>()..getAppointments(),
      child: BlocBuilder<AppointmentCubit, AppointmentState>(
        builder: (context, state) {
          if (state is AppointmentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AppointmentError) {
            return Center(
              child: Text(
                'Error loading patients',
                style: TextStyle(
                  color: ColorsManager.error,
                  fontSize: 14.sp,
                ),
              ),
            );
          }

          if (state is AppointmentLoaded) {
            final todayAppointments = state.appointments
                .where((appointment) =>
                    DateTime.parse(appointment.day).day == DateTime.now().day)
                .toList();

            final totalPatients = state.appointments
                .map((appointment) => appointment.patient)
                .toSet()
                .length;

            return Column(
              children: [
                StatsSectionWidget(
                  totalPatients: totalPatients,
                  todayAppointments: todayAppointments.length,
                  rating: 4.5, // This should come from your rating system
                ),
                SizedBox(height: 24.h),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, PageRouteNames.appointments);
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: ColorsManager.primary.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'My Patients',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorsManager.textDark,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16.sp,
                              color: ColorsManager.primary,
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        if (todayAppointments.isEmpty)
                          _buildNoPatients()
                        else
                          Column(
                            children: [
                              for (var appointment in todayAppointments.take(2))
                                Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: _buildPatientCard(
                                    patientName: appointment.patient,
                                    time: appointment.appointmentStart,
                                    type: appointment.clinic,
                                    status: 'Confirmed',
                                    statusColor: ColorsManager.success,
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildNoPatients() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ColorsManager.lightGray,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_alt_rounded,
            size: 48.sp,
            color: ColorsManager.textLight,
          ),
          SizedBox(height: 16.h),
          Text(
            'No patients for today',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: ColorsManager.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard({
    required String patientName,
    required String time,
    required String type,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ColorsManager.lightGray,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: ColorsManager.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                patientName.split(' ').map((e) => e[0]).join(''),
                style: TextStyle(
                  color: ColorsManager.primary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patientName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorsManager.textDark,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  type,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorsManager.textLight,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorsManager.textDark,
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
