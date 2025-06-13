import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_it/get_it.dart';
import '../cubit/doctors_by_specialty_cubit.dart';
import '../../data/models/doctor_by_specialty_model.dart';
import 'doctor_details_page.dart';

class DoctorsBySpecialtyPage extends StatelessWidget {
  final int specialtyId;
  final String specialtyName;

  const DoctorsBySpecialtyPage({
    super.key,
    required this.specialtyId,
    required this.specialtyName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<DoctorsBySpecialtyCubit>()
        ..getDoctorsBySpecialty(specialtyId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          title: Text(
            specialtyName,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF3B82F6),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocBuilder<DoctorsBySpecialtyCubit, DoctorsBySpecialtyState>(
          builder: (context, state) {
            if (state is DoctorsBySpecialtyLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DoctorsBySpecialtyLoaded) {
              if (state.doctors.isEmpty) {
                return Center(
                  child: Text(
                    'No doctors found in this specialty',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: state.doctors.length,
                itemBuilder: (context, index) {
                  final doctor = state.doctors[index];
                  return _buildDoctorCard(context, doctor);
                },
              );
            } else if (state is DoctorsBySpecialtyError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, DoctorBySpecialtyModel doctor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailsPage(doctor: doctor),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
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
        child: Row(
          children: [
            // Doctor Image
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  bottomLeft: Radius.circular(12.r),
                ),
              ),
              child: doctor.profilePic != null
                  ? CachedNetworkImage(
                      imageUrl: 'http://medlink.runasp.net${doctor.profilePic}',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                const Color(0xFF3B82F6)),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.person,
                            size: 40.sp, color: Colors.grey[400]),
                      ),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.person,
                          size: 40.sp, color: Colors.grey[400]),
                    ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dr. ${doctor.firstName} ${doctor.lastName}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    doctor.speciality ?? 'No specialty',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  if (doctor.rate != null) ...[
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18.sp),
                        SizedBox(width: 4.w),
                        Text(
                          doctor.rate.toString(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
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
    );
  }
}
