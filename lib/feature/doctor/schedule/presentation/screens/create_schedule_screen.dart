import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widgets/app_text_button.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../core/utils/color_manger.dart';
import '../cubit/schedule_cubit.dart';
import '../../data/models/clinic_model.dart';

class CreateScheduleScreen extends StatefulWidget {
  const CreateScheduleScreen({super.key});

  @override
  State<CreateScheduleScreen> createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedDay;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  ClinicModel? _selectedClinic;

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
    context.read<ScheduleCubit>().getClinics();
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

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _selectedClinic != null &&
        _startTime != null &&
        _endTime != null) {
      if (_endTime!.hour < _startTime!.hour ||
          (_endTime!.hour == _startTime!.hour &&
              _endTime!.minute <= _startTime!.minute)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End time must be after start time'),
            backgroundColor: ColorsManager.error,
          ),
        );
        return;
      }

      context.read<ScheduleCubit>().createSchedule(
            day: _selectedDay!,
            appointmentStart: _startTime!.format(context),
            appointmentEnd: _endTime!.format(context),
            clinicId: _selectedClinic!.id,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.background,
      appBar: AppBar(
        title: Text(
          'Create Schedule',
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
                SnackBar(content: Text(state.message)),
              );
            } else if (state is ScheduleCreated) {
              context.read<ScheduleCubit>().getSchedule();
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
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
                              ColorsManager.primary.withOpacity(0.1),
                              ColorsManager.secondary.withOpacity(0.1),
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
                                color: ColorsManager.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.calendar_today,
                                size: 32.w,
                                color: ColorsManager.primary,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Create New Schedule',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorsManager.primary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Fill in the details to create your schedule',
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
                                  begin: const Offset(0, 0.2),
                                  duration: 600.ms),
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
                                            margin:
                                                EdgeInsets.only(bottom: 16.h),
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
                                  text: _selectedClinic?.name ?? '',
                                ),
                                validator: (value) {
                                  if (_selectedClinic == null) {
                                    return 'Please select a clinic';
                                  }
                                  return null;
                                },
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
                                        borderRadius:
                                            BorderRadius.circular(2.r),
                                      ),
                                    ),
                                    ..._days.map((day) {
                                      return ListTile(
                                        title: Text(
                                          day,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color:
                                                Colors.black.withOpacity(0.7),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _selectedDay = day;
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
                            text: _selectedDay ?? '',
                          ),
                          validator: (value) {
                            if (_selectedDay == null) {
                              return 'Please select a day';
                            }
                            return null;
                          },
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
                              child: TextButton(
                                onPressed: () => _selectTime(context, true),
                                child: Text(
                                  _startTime?.format(context) ??
                                      'Select Start Time',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                  ),
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
                              child: TextButton(
                                onPressed: () => _selectTime(context, false),
                                child: Text(
                                  _endTime?.format(context) ??
                                      'Select End Time',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Submit Button
                    Animate(
                      effects: [
                        FadeEffect(duration: 600.ms),
                        SlideEffect(
                            begin: const Offset(0, 0.2), duration: 600.ms),
                      ],
                      delay: 800.ms,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          'Create Schedule',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
