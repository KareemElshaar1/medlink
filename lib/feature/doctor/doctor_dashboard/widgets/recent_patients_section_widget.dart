import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medlink/core/utils/color_manger.dart';
import 'package:medlink/core/routes/page_routes_name.dart';
import 'package:medlink/feature/doctor/schedule/presentation/cubit/schedule_cubit.dart';
import 'package:medlink/feature/doctor/schedule/data/models/schedule_model.dart';
import 'package:get_it/get_it.dart';

class MyScheduleSectionWidget extends StatelessWidget {
  const MyScheduleSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<ScheduleCubit>()..getSchedule(),
      child: BlocBuilder<ScheduleCubit, ScheduleState>(
        builder: (context, state) {
          if (state is ScheduleLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ScheduleError) {
            return Center(
              child: Text(
                'Error loading schedules',
                style: TextStyle(
                  color: ColorsManager.error,
                  fontSize: 14.sp,
                ),
              ),
            );
          }

          if (state is SchedulesLoaded) {
            final recentSchedules = state.schedules.take(2).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Schedule',
                        style: TextStyle(
                          color: ColorsManager.textDark,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, PageRouteNames.scheduleList);
                        },
                        icon: Icon(
                          Icons.arrow_forward_rounded,
                          size: 18.sp,
                          color: ColorsManager.primary,
                        ),
                        label: Text(
                          'View All',
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
                if (recentSchedules.isEmpty)
                  _buildNoSchedules()
                else
                  Column(
                    children: [
                      for (var schedule in recentSchedules)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          child: _buildScheduleCard(schedule),
                        ),
                    ],
                  ),
              ],
            );
          }

          return _buildNoSchedules();
        },
      ),
    );
  }

  Widget _buildNoSchedules() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.textLight.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: ColorsManager.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_note_rounded,
              size: 32.sp,
              color: ColorsManager.primary,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'No schedules found',
            style: TextStyle(
              color: ColorsManager.textDark,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Your schedules will appear here',
            style: TextStyle(
              color: ColorsManager.textLight,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(ScheduleModel schedule) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.textLight.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
              child: Icon(
                Icons.event_available_rounded,
                size: 24.sp,
                color: ColorsManager.primary,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.clinic,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorsManager.textDark,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${schedule.day} • ${schedule.appointmentStart} - ${schedule.appointmentEnd}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorsManager.textLight,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16.sp,
            color: ColorsManager.textLight,
          ),
        ],
      ),
    );
  }
}
