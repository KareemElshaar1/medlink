import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widgets/app_text_button.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../core/utils/color_manger.dart';
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
              primary: ColorsManager.primary,
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
          backgroundColor: ColorsManager.error,
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
      backgroundColor: ColorsManager.background,
      appBar: AppBar(
        title: Text(
          'Edit Schedule',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
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
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorsManager.background,
              ColorsManager.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: BlocConsumer<ScheduleCubit, ScheduleState>(
          listener: (context, state) {
            if (state is ScheduleError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: ColorsManager.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              );
            } else if (state is ScheduleEdited) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Schedule updated successfully'),
                  backgroundColor: ColorsManager.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Card
                  Animate(
                    effects: [
                      FadeEffect(duration: 600.ms),
                      SlideEffect(
                          begin: const Offset(0, 0.2), duration: 600.ms),
                    ],
                    child: Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ColorsManager.primary.withOpacity(0.1),
                            ColorsManager.secondary.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
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
                            children: [
                              Container(
                                padding: EdgeInsets.all(12.r),
                                decoration: BoxDecoration(
                                  color: ColorsManager.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.calendar_today,
                                  size: 24.w,
                                  color: ColorsManager.primary,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Edit Schedule',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: ColorsManager.primary,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Form Fields
                  Animate(
                    effects: [
                      FadeEffect(duration: 600.ms),
                      SlideEffect(
                          begin: const Offset(0, 0.2), duration: 600.ms),
                    ],
                    delay: 200.ms,
                    child: Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 20.w,
                                color: ColorsManager.primary,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Schedule Details',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsManager.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),

                          // Clinic Selection
                          BlocBuilder<ScheduleCubit, ScheduleState>(
                            builder: (context, state) {
                              if (state is ClinicsLoaded) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Clinic',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) => Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(20.r),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 40.w,
                                                  height: 4.h,
                                                  margin: EdgeInsets.only(
                                                    top: 8.h,
                                                    bottom: 16.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.r),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.w),
                                                  child: Text(
                                                    'Select Clinic',
                                                    style: TextStyle(
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          ColorsManager.primary,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 16.h),
                                                ...state.clinics.map((clinic) {
                                                  return ListTile(
                                                    leading: Icon(
                                                      Icons.medical_services,
                                                      color:
                                                          ColorsManager.primary,
                                                    ),
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
                                                        _selectedClinic =
                                                            clinic;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  );
                                                }),
                                                SizedBox(height: 16.h),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 12.h,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.medical_services,
                                                  size: 20.w,
                                                  color: ColorsManager.primary,
                                                ),
                                                SizedBox(width: 8.w),
                                                Text(
                                                  _selectedClinic?.name ??
                                                      widget.schedule.clinic,
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.black
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Icon(
                                              Icons.arrow_drop_down,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                          SizedBox(height: 20.h),

                          // Day Selection
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Day',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (context) => Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20.r),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 40.w,
                                            height: 4.h,
                                            margin: EdgeInsets.only(
                                              top: 8.h,
                                              bottom: 16.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(2.r),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Select Day',
                                                  style: TextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        ColorsManager.primary,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 16.h),
                                          Expanded(
                                            child: ListView.builder(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16.w),
                                              itemCount: _days.length,
                                              itemBuilder: (context, index) {
                                                final day = _days[index];
                                                final isSelected =
                                                    _dayController.text == day;
                                                return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      _dayController.text = day;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: 12.h,
                                                      horizontal: 16.w,
                                                    ),
                                                    margin: EdgeInsets.only(
                                                        bottom: 8.h),
                                                    decoration: BoxDecoration(
                                                      color: isSelected
                                                          ? ColorsManager
                                                              .primary
                                                              .withOpacity(0.1)
                                                          : Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                      border: Border.all(
                                                        color: isSelected
                                                            ? ColorsManager
                                                                .primary
                                                            : Colors.grey
                                                                .withOpacity(
                                                                    0.3),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.calendar_today,
                                                          size: 20.w,
                                                          color: isSelected
                                                              ? ColorsManager
                                                                  .primary
                                                              : Colors.black
                                                                  .withOpacity(
                                                                      0.5),
                                                        ),
                                                        SizedBox(width: 12.w),
                                                        Text(
                                                          day,
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            color: isSelected
                                                                ? ColorsManager
                                                                    .primary
                                                                : Colors.black
                                                                    .withOpacity(
                                                                        0.7),
                                                            fontWeight:
                                                                isSelected
                                                                    ? FontWeight
                                                                        .bold
                                                                    : FontWeight
                                                                        .normal,
                                                          ),
                                                        ),
                                                        if (isSelected) ...[
                                                          Spacer(),
                                                          Icon(
                                                            Icons.check_circle,
                                                            color: ColorsManager
                                                                .primary,
                                                            size: 20.w,
                                                          ),
                                                        ],
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.3),
                                    ),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: 20.w,
                                            color: ColorsManager.primary,
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            _dayController.text,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),

                          // Time Selection
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Start Time',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    InkWell(
                                      onTap: () => _selectTime(context, true),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 12.h,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time,
                                                  size: 20.w,
                                                  color: ColorsManager.primary,
                                                ),
                                                SizedBox(width: 8.w),
                                                Text(
                                                  _startTime != null
                                                      ? _formatTimeForApi(
                                                          _startTime!)
                                                      : _formatTimeForDisplay(
                                                          widget.schedule
                                                              .appointmentStart),
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.black
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Icon(
                                              Icons.arrow_drop_down,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'End Time',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    InkWell(
                                      onTap: () => _selectTime(context, false),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 12.h,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time,
                                                  size: 20.w,
                                                  color: ColorsManager.primary,
                                                ),
                                                SizedBox(width: 8.w),
                                                Text(
                                                  _endTime != null
                                                      ? _formatTimeForApi(
                                                          _endTime!)
                                                      : _formatTimeForDisplay(
                                                          widget.schedule
                                                              .appointmentEnd),
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.black
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Icon(
                                              Icons.arrow_drop_down,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                    delay: 400.ms,
                    child: ElevatedButton(
                      onPressed: state is ScheduleLoading ? null : _handleEdit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (state is ScheduleLoading)
                            SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          else
                            Icon(
                              Icons.save,
                              size: 20.w,
                            ),
                          SizedBox(width: 8.w),
                          Text(
                            state is ScheduleLoading
                                ? 'Saving...'
                                : 'Save Changes',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
