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
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Enhanced 3D Doctor Image Section
            Stack(
              children: [
                // Bottom shadow layer
                Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(0.05)
                    ..translate(0.0, 6.0, 0.0),
                  alignment: Alignment.center,
                  child: Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        bottomLeft: Radius.circular(16.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                // Middle accent layer
                Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(0.05)
                    ..translate(0.0, 3.0, 0.0),
                  alignment: Alignment.center,
                  child: Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        bottomLeft: Radius.circular(16.r),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF3B82F6).withOpacity(0.2),
                          const Color(0xFF3B82F6).withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                ),
                // Main image layer
                Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(0.05),
                  alignment: Alignment.center,
                  child: Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        bottomLeft: Radius.circular(16.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                          spreadRadius: 2,
                        ),
                        const BoxShadow(
                          color: Colors.white,
                          blurRadius: 10,
                          offset: Offset(-4, -4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        bottomLeft: Radius.circular(16.r),
                      ),
                      child: doctor.profilePic != null
                          ? CachedNetworkImage(
                              imageUrl:
                                  'http://medlink.runasp.net${doctor.profilePic}',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFF3B82F6).withOpacity(0.1),
                                      const Color(0xFF3B82F6).withOpacity(0.05),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF3B82F6)),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFF3B82F6).withOpacity(0.1),
                                      const Color(0xFF3B82F6).withOpacity(0.05),
                                    ],
                                  ),
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 50.sp,
                                  color: const Color(0xFF3B82F6),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF3B82F6).withOpacity(0.1),
                                    const Color(0xFF3B82F6).withOpacity(0.05),
                                  ],
                                ),
                              ),
                              child: Icon(
                                Icons.person,
                                size: 50.sp,
                                color: const Color(0xFF3B82F6),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. ${doctor.firstName} ${doctor.lastName}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: const Color(0xFF3B82F6).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        doctor.speciality ?? 'No specialty',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF3B82F6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    if (doctor.rate != null) ...[
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: Colors.amber.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 18.sp,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            doctor.rate.toString(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
