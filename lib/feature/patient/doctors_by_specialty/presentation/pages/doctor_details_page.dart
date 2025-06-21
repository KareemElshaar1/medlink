import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../data/models/doctor_by_specialty_model.dart';
import '../../../take_appointment/domain/entities/doctor_schedule.dart';
import '../../../take_appointment/presentation/cubit/doctor_schedule_cubit.dart';
import '../../../take_appointment/presentation/cubit/book_appointment_cubit.dart';
import '../../../take_appointment/data/models/book_appointment_model.dart';
import '../../../take_appointment/presentation/pages/booking_confirmation_page.dart';

class DoctorDetailsPage extends StatelessWidget {
  final DoctorBySpecialtyModel doctor;

  const DoctorDetailsPage({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GetIt.I<DoctorScheduleCubit>()..getDoctorSchedule(doctor.id),
        ),
        BlocProvider(
          create: (context) => GetIt.I<BookAppointmentCubit>(),
        ),
      ],
      child: _DoctorDetailsView(doctor: doctor),
    );
  }
}

class _DoctorDetailsView extends StatelessWidget {
  final DoctorBySpecialtyModel doctor;

  const _DoctorDetailsView({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Simple Background Image
                  doctor.profilePic != null
                      ? CachedNetworkImage(
                          imageUrl:
                              'http://medlink.runasp.net${doctor.profilePic}',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[100],
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF3B82F6)),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[100],
                            child: Icon(
                              Icons.person,
                              size: 80.sp,
                              color: Colors.grey[400],
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey[100],
                          child: Icon(
                            Icons.person,
                            size: 80.sp,
                            color: Colors.grey[400],
                          ),
                        ),
                  // Simple Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Doctor Info
                  Positioned(
                    bottom: 20.h,
                    left: 20.w,
                    right: 20.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. ${doctor.firstName} ${doctor.lastName}',
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          doctor.speciality ?? 'No specialty',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        if (doctor.rate != null) ...[
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(Icons.star,
                                  color: Colors.amber, size: 20.sp),
                              SizedBox(width: 4.w),
                              Text(
                                doctor.rate.toString(),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: Colors.white,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About Section
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
                        Row(
                          children: [
                            Icon(Icons.info_outline,
                                color: const Color(0xFF3B82F6), size: 24.sp),
                            SizedBox(width: 8.w),
                            Text(
                              'About',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          doctor.about ?? 'No information available',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Available Schedules Section
                  Text(
                    'Available Schedules',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  BlocBuilder<DoctorScheduleCubit, DoctorScheduleState>(
                    builder: (context, state) {
                      if (state is DoctorScheduleLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is DoctorScheduleError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (state is DoctorScheduleLoaded) {
                        if (state.schedules.isEmpty) {
                          return Center(
                            child: Text(
                              'No schedules available',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.schedules.length,
                          itemBuilder: (context, index) {
                            final schedule = state.schedules[index];
                            return _scheduleCard(schedule);
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scheduleCard(DoctorSchedule schedule) {
    return BlocConsumer<BookAppointmentCubit, BookAppointmentState>(
      listener: (context, state) {
        if (state is BookAppointmentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Appointment booked successfully!'),
              backgroundColor: Colors.green,
            ),
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
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
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
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16.r)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: const Color(0xFF3B82F6), size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          schedule.day,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF3B82F6),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${schedule.appointmentStart.split(':').take(2).join(':')} - ${schedule.appointmentEnd.split(':').take(2).join(':')}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF3B82F6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.business,
                            color: Colors.grey[600], size: 18.sp),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            schedule.clinic,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: Colors.grey[600], size: 18.sp),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            '${schedule.street}, ${schedule.city}, ${schedule.governate}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.grey[600], size: 18.sp),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () async {
                            await Clipboard.setData(
                                ClipboardData(text: schedule.phone));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Phone number copied to clipboard')),
                            );
                          },
                          child: Text(
                            schedule.phone,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.green,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ج ${schedule.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF3B82F6),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: state is BookAppointmentLoading
                              ? null
                              : () async {
                                  final appointment = BookAppointmentModel(
                                    doctorId: schedule.docId,
                                    clinicId: schedule.clinicId,
                                    day: schedule.day,
                                    appointmentStart: schedule.appointmentStart
                                        .split(':')
                                        .take(2)
                                        .join(':'),
                                    appointmentEnd: schedule.appointmentEnd
                                        .split(':')
                                        .take(2)
                                        .join(':'),
                                  );

                                  final result = await Navigator.push<bool>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BookingConfirmationPage(
                                        appointment: appointment,
                                        schedule: schedule,
                                      ),
                                    ),
                                  );

                                  if (result == true) {
                                    // Booking was successful, you can handle any additional logic here
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 12.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: state is BookAppointmentLoading
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  'Book Now',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
