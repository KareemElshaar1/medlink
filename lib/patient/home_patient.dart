import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import '../core/routes/page_routes_name.dart';
import 'recommendation_doctor/presentation/cubit/recommendation_doctor_cubit.dart';
import 'recommendation_doctor/domain/entities/recommendation_doctor.dart';
import '../feature/specilaity/manger/cubit/specialities_cubit.dart';
import '../feature/specilaity/domain/entities/speciality_entity.dart';
import '../feature/specilaity/presentation/pages/all_specialties_page.dart';
import '../feature/doctors_by_specialty/presentation/pages/doctors_by_specialty_page.dart';
import '../feature/doctors_by_specialty/data/models/doctor_by_specialty_model.dart';
import '../feature/doctors_by_specialty/presentation/pages/doctor_details_page.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../feature/search/presentation/cubit/search_cubit.dart';
import '../feature/search/presentation/pages/search_page.dart';

class HomePatient extends StatelessWidget {
  const HomePatient({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GetIt.I<RecommendationDoctorCubit>()..getRecommendationDoctors(),
        ),
        BlocProvider(
          create: (context) => GetIt.I<SpecialitiesCubit>()..getSpecialities(),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        body: SafeArea(
          child: Column(
            children: [
              // Modern Amazing AppBar
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                    left: 20.w, right: 20.w, top: 18.h, bottom: 28.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(32.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.10),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26.r,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image.network(
                              'https://randomuser.me/api/portraits/men/32.jpg',
                              width: 44.w,
                              height: 44.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, Omar!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'How are you today?',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.notifications_none_rounded,
                            color: Colors.white, size: 28.sp),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              // Main content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.h),
                        // 2. Blue card with doctor image and CTA
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(18.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF3B82F6),
                                    Color(0xFF60A5FA)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Book and schedule with\nnearest doctor',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 32.h),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.r),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24.w, vertical: 10.h),
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      'Find Nearby',
                                      style: TextStyle(
                                        color: Color(0xFF3B82F6),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: -36.h,
                              right: 18.w,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.10),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 48.r,
                                  backgroundColor: Colors.white,
                                  child: ClipOval(
                                    child: Image.network(
                                      'https://img.freepik.com/free-photo/portrait-smiling-male-doctor-standing-with-arms-crossed_23-2147896755.jpg',
                                      width: 90.w,
                                      height: 90.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 28.h),
                        // 3. Doctor Speciality Horizontal List
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Doctor Speciality',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                )),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AllSpecialtiesPage(),
                                  ),
                                );
                              },
                              child: Text('See All',
                                  style: TextStyle(
                                      color: Color(0xFF3B82F6),
                                      fontSize: 13.sp)),
                            ),
                          ],
                        ),
                        BlocBuilder<SpecialitiesCubit, SpecialitiesState>(
                          builder: (context, state) {
                            if (state is SpecialitiesLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is SpecialitiesLoaded) {
                              return SizedBox(
                                height: 90.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: state.specialities.length,
                                  itemBuilder: (context, index) {
                                    final specialty = state.specialities[index];
                                    return _specialityItem(
                                      _getIconData(specialty.name),
                                      specialty.name,
                                      specialty.id,
                                    );
                                  },
                                ),
                              );
                            } else if (state is SpecialitiesError) {
                              return Center(child: Text(state.message));
                            }
                            return const SizedBox();
                          },
                        ),
                        SizedBox(height: 24.h),
                        // Recommendation Doctor Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Recommendation Doctor',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                )),
                            TextButton(
                              onPressed: () {
                                // TODO: Navigate to all doctors screen
                              },
                              child: Text('See All',
                                  style: TextStyle(
                                      color: Color(0xFF3B82F6),
                                      fontSize: 13.sp)),
                            ),
                          ],
                        ),
                        BlocBuilder<RecommendationDoctorCubit,
                            RecommendationDoctorState>(
                          builder: (context, state) {
                            if (state is RecommendationDoctorLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is RecommendationDoctorLoaded) {
                              return Column(
                                children: state.doctors
                                    .take(5)
                                    .map((doctor) => _doctorCard(doctor))
                                    .toList(),
                              );
                            } else if (state is RecommendationDoctorError) {
                              return Center(child: Text(state.message));
                            }
                            return const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _modernBottomNav(),
      ),
    );
  }

  Widget _specialityItem(IconData icon, String label, int specialtyId) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorsBySpecialtyPage(
                specialtyId: specialtyId,
                specialtyName: label,
              ),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.only(right: 18.w),
          child: Column(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: Colors.white,
                child: Icon(icon, color: Color(0xFF3B82F6), size: 28.sp),
              ),
              SizedBox(height: 8.h),
              Text(label,
                  style: TextStyle(fontSize: 13.sp, color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _doctorCard(RecommendationDoctor doctor) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          // Convert RecommendationDoctor to DoctorBySpecialtyModel
          final doctorModel = DoctorBySpecialtyModel(
            id: doctor.id,
            firstName: doctor.firstName,
            lastName: doctor.lastName,
            speciality: doctor.speciality,
            about: doctor.about,
            rate: doctor.rate,
            profilePic: doctor.profilePic,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorDetailsPage(doctor: doctorModel),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.only(top: 8.h, bottom: 16.h),
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: doctor.profilePic != null
                    ? Image.network(
                        'http://medlink.runasp.net${doctor.profilePic}',
                        width: 64.w,
                        height: 64.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 64.w,
                            height: 64.w,
                            color: Colors.grey[200],
                            child: Icon(Icons.person,
                                size: 32.sp, color: Colors.grey[400]),
                          );
                        },
                      )
                    : Container(
                        width: 64.w,
                        height: 64.w,
                        color: Colors.grey[200],
                        child: Icon(Icons.person,
                            size: 32.sp, color: Colors.grey[400]),
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
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      doctor.speciality,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18.sp),
                        SizedBox(width: 4.w),
                        Text(
                          doctor.rate?.toString() ?? 'N/A',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey[400],
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modernBottomNav() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.home_rounded, color: Color(0xFF3B82F6), size: 28.sp),
              Icon(Icons.chat_bubble_outline_rounded,
                  color: Colors.grey, size: 26.sp),
              SizedBox(width: 32.sp), // Placeholder for search icon
              Icon(Icons.calendar_month_rounded,
                  color: Colors.grey, size: 26.sp),
              Icon(Icons.person_rounded, color: Colors.grey, size: 26.sp),
            ],
          ),
        ),
        Positioned(
          top: -20.h,
          child: Builder(
            builder: (BuildContext context) => GestureDetector(
              onTap: () {
                print('Search icon tapped'); // Debug print
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => GetIt.instance<SearchCubit>(),
                      child: const SearchPage(),
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF3B82F6).withOpacity(0.15),
                      Color(0xFF60A5FA).withOpacity(0.15),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF3B82F6).withOpacity(0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 8,
                      offset: const Offset(0, -4),
                    ),
                  ],
                  border: Border.all(
                    color: Color(0xFF3B82F6).withOpacity(0.15),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.search_rounded,
                  color: Color(0xFF3B82F6),
                  size: 32.sp,
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(
                begin: const Offset(0.8, 0.8),
                duration: 600.ms,
                curve: Curves.easeOutBack,
              )
              .shimmer(
                duration: 1800.ms,
                color: Color(0xFF3B82F6).withOpacity(0.3),
              )
              .then()
              .shake(
                hz: 4,
                curve: Curves.easeInOut,
                duration: 1000.ms,
              ),
        ),
      ],
    );
  }

  IconData _getIconData(String specialtyName) {
    switch (specialtyName.toLowerCase()) {
      case 'general':
        return Icons.medical_services;
      case 'neurologic':
        return Icons.bubble_chart;
      case 'pediatric':
        return Icons.child_care;
      case 'radiology':
        return Icons.radar;
      case 'cardiology':
        return Icons.favorite;
      default:
        return Icons.medical_services;
    }
  }
}
