import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widgets/app_text_button.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../data/models/schedule_model.dart';
import '../../data/models/clinic_model.dart';
import '../cubit/schedule_cubit.dart';

class EditScheduleScreen extends StatefulWidget {
  final ScheduleModel schedule;

  const EditScheduleScreen({
    super.key,
    required this.schedule,
  });

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  late final TextEditingController _dayController;
  late final TextEditingController _startTimeController;
  late final TextEditingController _endTimeController;
  ClinicModel? _selectedClinic;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    _dayController = TextEditingController(text: widget.schedule.day);
    _startTimeController =
        TextEditingController(text: widget.schedule.appointmentStart);
    _endTimeController =
        TextEditingController(text: widget.schedule.appointmentEnd);
    context.read<ScheduleCubit>().getClinics();
  }

  @override
  void dispose() {
    _dayController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  String _formatTimeForApi(TimeOfDay time) {
    // Ensure 24-hour format with leading zeros
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatTimeForDisplay(String time) {
    try {
      // First try to parse as 24-hour format
      final parts = time.split(':');
      if (parts.length == 2) {
        int hour = int.tryParse(parts[0]) ?? 0;
        int minute = int.tryParse(parts[1]) ?? 0;

        // Ensure hour is in 24-hour format
        if (hour < 0) hour = 0;
        if (hour > 23) hour = 23;
        if (minute < 0) minute = 0;
        if (minute > 59) minute = 59;

        return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      // If parsing fails, return a default time
      return '00:00';
    }
    return '00:00';
  }

  void _handleEdit() {
    // Check if any field has been changed
    final hasDayChanged = _dayController.text != widget.schedule.day;
    final hasStartTimeChanged = _startTime != null;
    final hasEndTimeChanged = _endTime != null;
    final hasClinicChanged = _selectedClinic != null;

    // If no changes were made, show a message and return
    if (!hasDayChanged &&
        !hasStartTimeChanged &&
        !hasEndTimeChanged &&
        !hasClinicChanged) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes were made')),
      );
      return;
    }

    // Validate only the fields that were changed
    if (hasDayChanged && _dayController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid day')),
      );
      return;
    }

    if ((hasStartTimeChanged || hasEndTimeChanged) &&
        (_startTime == null || _endTime == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid times')),
      );
      return;
    }

    if (_endTime != null &&
        _startTime != null &&
        (_endTime!.hour < _startTime!.hour ||
            (_endTime!.hour == _startTime!.hour &&
                _endTime!.minute <= _startTime!.minute))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End time must be after start time'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Format times for API
    final formattedStartTime = hasStartTimeChanged
        ? _formatTimeForApi(_startTime!)
        : _formatTimeForDisplay(widget.schedule.appointmentStart);

    final formattedEndTime = hasEndTimeChanged
        ? _formatTimeForApi(_endTime!)
        : _formatTimeForDisplay(widget.schedule.appointmentEnd);

    // Get the current clinic from the clinics list that matches the schedule's clinic name
    final currentState = context.read<ScheduleCubit>().state;
    final currentClinic = currentState is ClinicsLoaded
        ? currentState.clinics.firstWhere(
            (clinic) => clinic.name == widget.schedule.clinic,
            orElse: () => currentState.clinics.first,
          )
        : null;

    context.read<ScheduleCubit>().editSchedule(
          id: widget.schedule.id,
          day: hasDayChanged ? _dayController.text : widget.schedule.day,
          appointmentStart: formattedStartTime,
          appointmentEnd: formattedEndTime,
          clinicId: hasClinicChanged
              ? _selectedClinic!.id
              : currentClinic?.id ?? widget.schedule.id,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Edit Schedule',
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
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
            } else if (state is ScheduleEdited) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section
                  Animate(
                    effects: [
                      FadeEffect(duration: 600.ms),
                      SlideEffect(
                          begin: const Offset(0, 0.2), duration: 600.ms),
                    ],
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.1),
                            AppColors.secondary.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.calendar_today,
                              size: 32.w,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Edit Schedule',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Update your schedule details',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Clinic Dropdown
                  BlocBuilder<ScheduleCubit, ScheduleState>(
                    builder: (context, state) {
                      if (state is ClinicsLoaded) {
                        return Animate(
                          effects: [
                            FadeEffect(duration: 600.ms),
                            SlideEffect(
                                begin: const Offset(0, 0.2), duration: 600.ms),
                          ],
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: AppTextFormField(
                              hintText: 'Select Clinic',
                              labelText: 'Clinic',
                              readOnly: true,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20.r),
                                    ),
                                  ),
                                  builder: (context) => Container(
                                    padding: EdgeInsets.all(16.w),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 40.w,
                                          height: 4.h,
                                          margin: EdgeInsets.only(bottom: 16.h),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(2.r),
                                          ),
                                        ),
                                        ...state.clinics.map((clinic) {
                                          return ListTile(
                                            title: Text(
                                              clinic.name,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.black
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                _selectedClinic = clinic;
                                              });
                                              Navigator.pop(context);
                                            },
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              controller: TextEditingController(
                                text: _selectedClinic?.name ??
                                    widget.schedule.clinic,
                              ),
                            ),
                          ),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Day Dropdown
                  Animate(
                    effects: [
                      FadeEffect(duration: 600.ms),
                      SlideEffect(
                          begin: const Offset(0, 0.2), duration: 600.ms),
                    ],
                    delay: 200.ms,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: AppTextFormField(
                        hintText: 'Select Day',
                        labelText: 'Day',
                        readOnly: true,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.r),
                              ),
                            ),
                            builder: (context) => Container(
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 40.w,
                                    height: 4.h,
                                    margin: EdgeInsets.only(bottom: 16.h),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(2.r),
                                    ),
                                  ),
                                  ..._days.map((day) {
                                    return ListTile(
                                      title: Text(
                                        day,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.black.withOpacity(0.7),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _dayController.text = day;
                                        });
                                        Navigator.pop(context);
                                      },
                                    );
                                  }),
                                ],
                              ),
                            ),
                          );
                        },
                        controller: _dayController,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Time Selection Row
                  Animate(
                    effects: [
                      FadeEffect(duration: 600.ms),
                      SlideEffect(
                          begin: const Offset(0, 0.2), duration: 600.ms),
                    ],
                    delay: 400.ms,
                    child: Row(
                      children: [
                        // Start Time
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: AppTextFormField(
                              hintText: 'Start Time',
                              labelText: 'Start Time',
                              readOnly: true,
                              onTap: () => _selectTime(context, true),
                              controller: TextEditingController(
                                text: _startTime != null
                                    ? _formatTimeForApi(_startTime!)
                                    : _formatTimeForDisplay(
                                        widget.schedule.appointmentStart),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        // End Time
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: AppTextFormField(
                              hintText: 'End Time',
                              labelText: 'End Time',
                              readOnly: true,
                              onTap: () => _selectTime(context, false),
                              controller: TextEditingController(
                                text: _endTime != null
                                    ? _formatTimeForApi(_endTime!)
                                    : _formatTimeForDisplay(
                                        widget.schedule.appointmentEnd),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Save Button
                  Animate(
                    effects: [
                      FadeEffect(duration: 600.ms),
                      SlideEffect(
                          begin: const Offset(0, 0.2), duration: 600.ms),
                    ],
                    delay: 800.ms,
                    child: ElevatedButton(
                      onPressed: state is ScheduleLoading ? null : _handleEdit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        state is ScheduleLoading ? 'Saving...' : 'Save Changes',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
