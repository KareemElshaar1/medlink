import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../../core/routes/page_routes_name.dart';
import '../cubit/schedule_cubit.dart';
import '../../data/models/schedule_model.dart';
import '../widgets/schedule_loading_widget.dart';
import '../widgets/schedule_empty_widget.dart';
import '../widgets/schedule_error_widget.dart';
import '../widgets/schedule_card.dart';
import 'edit_schedule_screen.dart';

class ScheduleListScreen extends StatefulWidget {
  const ScheduleListScreen({super.key});

  @override
  State<ScheduleListScreen> createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ScheduleCubit>().getSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Schedule',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.r),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: BlocConsumer<ScheduleCubit, ScheduleState>(
          listener: (context, state) {
            if (state is ScheduleError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is ScheduleLoading) {
              return const ScheduleLoadingWidget();
            }

            if (state is ScheduleError) {
              return ScheduleErrorWidget(
                message: state.message,
                onRetry: () => context.read<ScheduleCubit>().getSchedule(),
              );
            }

            if (state is SchedulesLoaded) {
              if (state.schedules.isEmpty) {
                return ScheduleEmptyWidget(
                  onAddSchedule: () {
                    Navigator.pushNamed(context, PageRouteNames.createSchedule)
                        .then((_) {
                      if (mounted) {
                        context.read<ScheduleCubit>().getSchedule();
                      }
                    });
                  },
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: state.schedules.length,
                itemBuilder: (context, index) {
                  final schedule = state.schedules[index];
                  return ScheduleCard(
                    schedule: schedule,
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditScheduleScreen(
                            schedule: schedule,
                          ),
                        ),
                      ).then((_) {
                        if (mounted) {
                          context.read<ScheduleCubit>().getSchedule();
                        }
                      });
                    },
                    onDelete: () =>
                        _showDeleteConfirmationDialog(context, schedule),
                  );
                },
              );
            }

            return ScheduleEmptyWidget(
              onAddSchedule: () {},
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, PageRouteNames.createSchedule).then((_) {
            if (mounted) {
              context.read<ScheduleCubit>().getSchedule();
            }
          });
        },
        tooltip: 'Add New Schedule',
        icon: Icon(
          Icons.add_rounded,
          size: 24.sp,
        ),
        label: Text(
          'Add Schedule',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, ScheduleModel schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Schedule',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this schedule?',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black.withOpacity(0.7),
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
                color: Colors.black,
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ScheduleCubit>().deleteSchedule(schedule.id);
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: AppColors.error,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
