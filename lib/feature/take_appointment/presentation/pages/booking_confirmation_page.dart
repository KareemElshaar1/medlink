import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../../data/models/book_appointment_model.dart';
import '../cubit/book_appointment_cubit.dart';
import '../../../take_appointment/domain/entities/doctor_schedule.dart';
import 'package:medlink/core/routes/page_routes_name.dart';

class BookingConfirmationPage extends StatefulWidget {
  final BookAppointmentModel appointment;
  final DoctorSchedule schedule;

  const BookingConfirmationPage({
    super.key,
    required this.appointment,
    required this.schedule,
  });

  @override
  State<BookingConfirmationPage> createState() =>
      _BookingConfirmationPageState();
}

class _BookingConfirmationPageState extends State<BookingConfirmationPage> {
  late DateTime selectedDate;
  late TimeOfDay selectedStartTime;
  late TimeOfDay selectedEndTime;
  late TimeOfDay clinicStartTime;
  late TimeOfDay clinicEndTime;

  @override
  void initState() {
    super.initState();
    // Initialize with current date
    selectedDate = DateTime.now();

    // Parse clinic schedule times from the schedule
    clinicStartTime = _parseTimeOfDay(widget.schedule.appointmentStart);
    clinicEndTime = _parseTimeOfDay(widget.schedule.appointmentEnd);

    // Initialize selected times with clinic times
    selectedStartTime = clinicStartTime;
    selectedEndTime = clinicEndTime; // Keep end time constant
  }

  String _formatTimeForDisplay(String time) {
    // Remove any extra spaces and ensure consistent format
    time = time.trim();

    // Split the time string and take only hours and minutes
    final parts = time.split(':');
    if (parts.length >= 2) {
      final hour = parts[0].padLeft(2, '0');
      final minute = parts[1].padLeft(2, '0');
      return '$hour:$minute';
    }
    return time;
  }

  TimeOfDay _parseTimeOfDay(String time) {
    try {
      // Remove any extra spaces
      time = time.trim();

      // Split the time string and take only hours and minutes
      final parts = time.split(':');
      if (parts.length >= 2) {
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);

        // Validate hour and minute ranges
        if (hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
          return TimeOfDay(hour: hour, minute: minute);
        }
      }
    } catch (e) {
      debugPrint('Error parsing time: $e');
    }
    // Fallback to current time if parsing fails
    final now = DateTime.now();
    return TimeOfDay(hour: now.hour, minute: now.minute);
  }

  String _formatTimeOfDay(TimeOfDay time) {
    // Format time in 24-hour format (HH:mm)
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  bool _isTimeWithinClinicHours(TimeOfDay time) {
    // Check if the time is within clinic operating hours
    if (time.hour < clinicStartTime.hour || time.hour > clinicEndTime.hour) {
      return false;
    }
    if (time.hour == clinicStartTime.hour &&
        time.minute < clinicStartTime.minute) {
      return false;
    }
    if (time.hour == clinicEndTime.hour && time.minute > clinicEndTime.minute) {
      return false;
    }
    return true;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      selectableDayPredicate: (DateTime date) {
        final dayName = DateFormat('EEEE').format(date);
        return dayName == widget.schedule.day;
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    // Only allow selecting start time
    if (!isStartTime) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End time is fixed based on clinic schedule'),
          backgroundColor: Colors.blue,
        ),
      );
      return;
    }

    // Get start and end times directly from schedule
    final startTime = _formatTimeForDisplay(widget.schedule.appointmentStart);
    final endTime = _formatTimeForDisplay(widget.schedule.appointmentEnd);

    // Generate list of available time slots (30-minute intervals)
    final List<String> availableTimeSlots = [];
    int startHour = int.parse(startTime.split(':')[0]);
    int startMinute = int.parse(startTime.split(':')[1]);
    int endHour = int.parse(endTime.split(':')[0]);
    int endMinute = int.parse(endTime.split(':')[1]);

    // Convert to minutes for easier calculation
    int startTotalMinutes = startHour * 60 + startMinute;
    int endTotalMinutes = endHour * 60 + endMinute;

    // Add time slots in 30-minute intervals
    for (int minutes = startTotalMinutes;
        minutes < endTotalMinutes;
        minutes += 30) {
      int hour = minutes ~/ 60;
      int minute = minutes % 60;
      String timeStr =
          '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      availableTimeSlots.add(timeStr);
    }

    // Show dialog with available time slots as cards in a grid
    final String? picked = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Start Time',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.grey[600]),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Clinic Hours Info
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              color: Colors.blue, size: 20.sp),
                          SizedBox(width: 8.w),
                          Text(
                            'Clinic Hours',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Available: ${_formatTimeForDisplay(widget.schedule.appointmentStart)} - ${_formatTimeForDisplay(widget.schedule.appointmentEnd)}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                // Current selection info
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Colors.green, size: 20.sp),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'End time is fixed at ${_formatTimeOfDay(selectedEndTime)}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.green[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                // Time selection grid
                Flexible(
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 2.2,
                    ),
                    itemCount: availableTimeSlots.length,
                    itemBuilder: (context, index) {
                      final time = availableTimeSlots[index];
                      final isSelected =
                          time == _formatTimeOfDay(selectedStartTime);
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop(time);
                          },
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isSelected
                                    ? [
                                        Colors.blue,
                                        Colors.blue.withOpacity(0.8)
                                      ]
                                    : [
                                        Colors.blue.withOpacity(0.1),
                                        Colors.blue.withOpacity(0.05)
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.blue.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                time,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.blue[800],
                                ),
                              ),
                            ),
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
    );

    if (picked != null) {
      setState(() {
        final parts = picked.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        selectedStartTime = TimeOfDay(hour: hour, minute: minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<BookAppointmentCubit>(),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Confirm Booking'),
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: Colors.white,
          ),
          body: BlocConsumer<BookAppointmentCubit, BookAppointmentState>(
            listener: (context, state) {
              if (state is BookAppointmentSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Appointment booked successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
                // Navigate to payment page with the appointment ID
                Navigator.pushNamed(
                  context,
                  PageRouteNames.payment,
                  arguments: {'appointmentId': state.appointmentId},
                );
              } else if (state is BookAppointmentError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Selection Card
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Date & Time',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          // Date Selection
                          ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: const Text('Select Date'),
                            subtitle: Text(
                              DateFormat('EEEE, MMMM d, yyyy')
                                  .format(selectedDate),
                            ),
                            onTap: () => _selectDate(context),
                          ),
                          const Divider(),
                          // Time Selection
                          ListTile(
                            leading: const Icon(Icons.access_time),
                            title: const Text('Start Time'),
                            subtitle: Text(_formatTimeOfDay(selectedStartTime)),
                            onTap: () => _selectTime(context, true),
                          ),
                          ListTile(
                            leading: const Icon(Icons.access_time),
                            title: const Text('End Time'),
                            subtitle: Text(_formatTimeOfDay(selectedEndTime)),
                            onTap: () => _selectTime(context, false),
                          ),
                          SizedBox(height: 8.h),
                          // Clinic Hours Info
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.info_outline,
                                        color: Colors.blue, size: 20.sp),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Clinic Schedule',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[700],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Day: ${widget.schedule.day}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.blue[700],
                                  ),
                                ),
                                Text(
                                  'Hours: ${widget.schedule.appointmentStart.split(':').take(2).join(':')} - ${widget.schedule.appointmentEnd.split(':').take(2).join(':')}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.blue[700],
                                  ),
                                ),
                                Text(
                                  'Clinic: ${widget.schedule.clinic}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.blue[700],
                                  ),
                                ),
                                Text(
                                  'Price: ج ${widget.schedule.price ?? '0'}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Confirmation Message
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.blue, size: 24.sp),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'Please confirm your appointment details before proceeding.',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),
                    // Book Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is BookAppointmentLoading
                            ? null
                            : () {
                                final updatedAppointment = BookAppointmentModel(
                                  doctorId: widget.appointment.doctorId,
                                  clinicId: widget.appointment.clinicId,
                                  day: DateFormat('yyyy-MM-dd')
                                      .format(selectedDate),
                                  appointmentStart:
                                      _formatTimeOfDay(selectedStartTime),
                                  appointmentEnd:
                                      _formatTimeOfDay(selectedEndTime),
                                );
                                context
                                    .read<BookAppointmentCubit>()
                                    .bookAppointment(updatedAppointment);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: state is BookAppointmentLoading
                            ? SizedBox(
                                width: 24.w,
                                height: 24.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                'Confirm Booking',
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
      ),
    );
  }
}
