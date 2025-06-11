import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import '../../../../../core/utils/color_manger.dart';
import '../../../../../../core/routes/page_routes_name.dart';
import '../cubit/schedule_cubit.dart';
import '../../data/models/schedule_model.dart';
import '../widgets/schedule_loading_widget.dart';
import '../widgets/schedule_empty_widget.dart';
import '../widgets/schedule_error_widget.dart';
import '../widgets/schedule_card.dart';
import 'edit_schedule_screen.dart';

class ScheduleListScreen extends StatelessWidget {
  const ScheduleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = GetIt.instance<ScheduleCubit>();
        cubit.getSchedule();
        return cubit;
      },
      child: const _ScheduleListContent(),
    );
  }
}

class _ScheduleListContent extends StatefulWidget {
  const _ScheduleListContent();

  @override
  State<_ScheduleListContent> createState() => _ScheduleListContentState();
}

class _ScheduleListContentState extends State<_ScheduleListContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'My Schedule',
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
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, size: 22.sp),
            onPressed: () => context.read<ScheduleCubit>().getSchedule(),
          ),
        ],
      ),
      body: BlocConsumer<ScheduleCubit, ScheduleState>(
        listenWhen: (previous, current) =>
            current is ScheduleError || current is ScheduleDeleted,
        listener: (context, state) {
          if (state is ScheduleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ColorsManager.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is ScheduleDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Schedule deleted successfully'),
                backgroundColor: ColorsManager.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        buildWhen: (previous, current) =>
            current is ScheduleLoading ||
            current is ScheduleError ||
            current is SchedulesLoaded,
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

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      '${state.schedules.length} Schedules',
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
                        final schedule = state.schedules[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: ScheduleCard(
                            schedule: schedule,
                            onEdit: () {
                              Navigator.pushNamed(
                                context,
                                PageRouteNames.editSchedule,
                                arguments: schedule,
                              ).then((_) {
                                if (mounted) {
                                  context.read<ScheduleCubit>().getSchedule();
                                }
                              });
                            },
                            onDelete: () => _showDeleteConfirmationDialog(
                                context, schedule),
                          ),
                        );
                      },
                      childCount: state.schedules.length,
                    ),
                  ),
                ),
              ],
            );
          }

          return ScheduleEmptyWidget(
            onAddSchedule: () {},
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, PageRouteNames.createSchedule).then((_) {
            if (mounted) {
              context.read<ScheduleCubit>().getSchedule();
            }
          });
        },
        backgroundColor: ColorsManager.primary,
        child: Icon(
          Icons.add_rounded,
          size: 24.sp,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, ScheduleModel schedule) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ScheduleCubit>(),
        child: BlocBuilder<ScheduleCubit, ScheduleState>(
          builder: (context, state) {
            return AlertDialog(
              title: Text(
                'Delete Schedule',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: Text(
                'Are you sure you want to delete this schedule?',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: state is ScheduleLoading
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
                  onPressed: state is ScheduleLoading
                      ? null
                      : () {
                          Navigator.pop(context);
                          context
                              .read<ScheduleCubit>()
                              .deleteSchedule(schedule.id);
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
