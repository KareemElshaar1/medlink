import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:medlink/feature/patient/payment/presentation/pages/payment_page.dart';
import 'package:medlink/feature/patient/profile/presentation/cubit/patient_profile_cubit.dart';
import 'package:medlink/feature/patient/profile/presentation/pages/patient_profile_page.dart';
import 'package:medlink/feature/patient/search/presentation/cubit/search_cubit.dart';
import 'package:medlink/feature/patient/search/presentation/pages/search_page.dart';
import 'package:medlink/feature/patient/specilaity/manger/cubit/specialities_cubit.dart';
import 'package:medlink/feature/patient/specilaity/presentation/pages/all_specialties_page.dart';
import 'package:medlink/feature/pharmacy/presentation/product_page.dart';
import 'package:medlink/feature/pharmacy/presentation/cubit/product_cubit.dart';
import 'package:medlink/features/ml_service/presentation/screens/dosage_prediction_screen.dart';

import '../../../../../core/utils/color_manger.dart';
import 'doctors_by_specialty/data/models/doctor_by_specialty_model.dart';
import 'doctors_by_specialty/presentation/pages/all_doctors_page.dart';
import 'doctors_by_specialty/presentation/pages/doctor_details_page.dart';
import 'doctors_by_specialty/presentation/pages/doctors_by_specialty_page.dart';
import 'recommendation_doctor/domain/entities/recommendation_doctor.dart';
import 'recommendation_doctor/presentation/cubit/recommendation_doctor_cubit.dart';

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
        BlocProvider(
          create: (context) => GetIt.I<PatientProfileCubit>()..loadProfile(),
        ),
      ],
      child: const HomePatientContent(),
    );
  }
}

class AutoScrollDoctorCard extends StatelessWidget {
  final RecommendationDoctor doctor;

  const AutoScrollDoctorCard({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    print(
        'AutoScrollDoctorCard profile pic: ${doctor.profilePic}'); // Debug log
    return GestureDetector(
      onTap: () {
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
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              const Color(0xFFF8FAFC),
              ColorsManager.primary.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.primary.withOpacity(0.15),
              blurRadius: 25,
              offset: const Offset(0, 12),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative background elements
            Positioned(
              right: -40.w,
              top: -40.h,
              child: Container(
                width: 180.w,
                height: 180.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      ColorsManager.primary.withOpacity(0.1),
                      ColorsManager.primary.withOpacity(0.05),
                      ColorsManager.primary.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: -30.w,
              bottom: -30.h,
              child: Container(
                width: 140.w,
                height: 140.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      ColorsManager.secondary.withOpacity(0.1),
                      ColorsManager.secondary.withOpacity(0.05),
                      ColorsManager.secondary.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
            // Main content
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Row(
                children: [
                  // Enhanced 3D Profile Picture Section
                  Stack(
                    children: [
                      // Bottom shadow layer
                      Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(0.05)
                          ..translate(0.0, 8.0, 0.0),
                        alignment: Alignment.center,
                        child: Container(
                          width: 130.w,
                          height: 130.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
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
                          ..translate(0.0, 4.0, 0.0),
                        alignment: Alignment.center,
                        child: Container(
                          width: 130.w,
                          height: 130.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.r),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                ColorsManager.primary.withOpacity(0.2),
                                ColorsManager.secondary.withOpacity(0.2),
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
                          width: 130.w,
                          height: 130.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow: [
                              BoxShadow(
                                color: ColorsManager.primary.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                                spreadRadius: 2,
                              ),
                              const BoxShadow(
                                color: Colors.white,
                                blurRadius: 12,
                                offset: Offset(-6, -6),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24.r),
                            child: doctor.profilePic != null
                                ? CachedNetworkImage(
                                    imageUrl: doctor.profilePic!
                                            .startsWith('http')
                                        ? doctor.profilePic!
                                        : 'http://medlink.runasp.net${doctor.profilePic}',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            ColorsManager.primary
                                                .withOpacity(0.1),
                                            ColorsManager.secondary
                                                .withOpacity(0.1),
                                          ],
                                        ),
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  ColorsManager.primary),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) {
                                      print(
                                          'Error loading image: $error'); // Debug log
                                      return Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              ColorsManager.primary
                                                  .withOpacity(0.1),
                                              ColorsManager.secondary
                                                  .withOpacity(0.1),
                                            ],
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          size: 70.w,
                                          color: ColorsManager.primary,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          ColorsManager.primary
                                              .withOpacity(0.1),
                                          ColorsManager.secondary
                                              .withOpacity(0.1),
                                        ],
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      size: 70.w,
                                      color: ColorsManager.primary,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 24.w),
                  // Doctor Information Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Dr. ${doctor.firstName} ${doctor.lastName}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22.sp,
                            color: ColorsManager.textDark,
                            height: 1.2,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: ColorsManager.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: ColorsManager.primary.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            doctor.speciality,
                            style: TextStyle(
                              color: ColorsManager.primary,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        SizedBox(height: 14.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: Colors.amber.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 22.sp,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              doctor.rate?.toString() ?? 'N/A',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                                color: ColorsManager.textDark,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePatientContent extends StatefulWidget {
  const HomePatientContent({super.key});

  @override
  State<HomePatientContent> createState() => _HomePatientContentState();
}

class _HomePatientContentState extends State<HomePatientContent> {
  final PageController _pageController = PageController();
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        if (_currentPage < 4) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _refreshData(BuildContext context) async {
    final profileCubit = context.read<PatientProfileCubit>();
    final recommendationCubit = context.read<RecommendationDoctorCubit>();
    final specialitiesCubit = context.read<SpecialitiesCubit>();

    await Future.wait([
      profileCubit.loadProfile(),
      recommendationCubit.getRecommendationDoctors(),
      specialitiesCubit.getSpecialities(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: BlocListener<PatientProfileCubit, PatientProfileState>(
          listener: (context, state) {
            if (state is PatientProfileLoaded) {
              context
                  .read<RecommendationDoctorCubit>()
                  .getRecommendationDoctors();
              context.read<SpecialitiesCubit>().getSpecialities();
            }
          },
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                    left: 24.w, right: 24.w, top: 20.h, bottom: 32.h),
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
                child: BlocBuilder<PatientProfileCubit, PatientProfileState>(
                  builder: (context, state) {
                    final profile =
                        state is PatientProfileLoaded ? state.profile : null;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PatientProfilePage(),
                                  ),
                                );
                                if (result == true) {
                                  await context
                                      .read<PatientProfileCubit>()
                                      .loadProfile();
                                }
                              },
                              child: CircleAvatar(
                                radius: 28.r,
                                backgroundColor: Colors.white,
                                child: ClipOval(
                                  child: profile?.profilePic != null
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              'http://medlink.runasp.net/UserProfilePic/${profile!.profilePic!.split('/').last}',
                                          width: 48.w,
                                          height: 48.w,
                                          fit: BoxFit.cover,
                                          memCacheWidth: 200,
                                          memCacheHeight: 200,
                                          maxWidthDiskCache: 200,
                                          maxHeightDiskCache: 200,
                                          cacheKey:
                                              '${profile.profilePic}_${DateTime.now().millisecondsSinceEpoch}',
                                          placeholder: (context, url) =>
                                              Container(
                                            width: 48.w,
                                            height: 48.w,
                                            color: Colors.grey[200],
                                            child: Icon(Icons.person,
                                                size: 36.sp,
                                                color: Colors.grey[400]),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            width: 48.w,
                                            height: 48.w,
                                            color: Colors.grey[200],
                                            child: Icon(Icons.person,
                                                size: 36.sp,
                                                color: Colors.grey[400]),
                                          ),
                                        )
                                      : Container(
                                          width: 48.w,
                                          height: 48.w,
                                          color: Colors.grey[200],
                                          child: Icon(Icons.person,
                                              size: 36.sp,
                                              color: Colors.grey[400]),
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hi, ${profile?.name ?? 'User'}!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'How are you today?',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: Colors.white.withOpacity(0.18),
                        //     shape: BoxShape.circle,
                        //   ),
                        //   child: IconButton(
                        //     icon: Icon(Icons.notifications_none_rounded,
                        //         color: Colors.white, size: 30.sp),
                        //     onPressed: () {},
                        //   ),
                        // ),
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => _refreshData(context),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12.h),
                          // Auto-scrolling Doctor List
                          BlocBuilder<RecommendationDoctorCubit,
                              RecommendationDoctorState>(
                            builder: (context, state) {
                              if (state is RecommendationDoctorLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (state is RecommendationDoctorLoaded) {
                                return AutoScrollDoctorList(
                                    doctors: state.doctors);
                              }
                              return const SizedBox();
                            },
                          ),
                          SizedBox(height: 32.h),
                          // Doctor Speciality Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Doctor Speciality',
                                  style: TextStyle(
                                    fontSize: 18.sp,
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
                                        color: const Color(0xFF3B82F6),
                                        fontSize: 14.sp)),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          BlocBuilder<SpecialitiesCubit, SpecialitiesState>(
                            builder: (context, state) {
                              if (state is SpecialitiesLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (state is SpecialitiesLoaded) {
                                return SizedBox(
                                  height: 100.h,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.specialities.length,
                                    itemBuilder: (context, index) {
                                      final specialty =
                                          state.specialities[index];
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
                          SizedBox(height: 32.h),
                          // Original Recommendation Doctor Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Recommendation Doctor',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  )),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AllDoctorsPage(),
                                    ),
                                  );
                                },
                                child: Text('See All',
                                    style: TextStyle(
                                        color: const Color(0xFF3B82F6),
                                        fontSize: 14.sp)),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
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
                          SizedBox(height: 32.h),
                          // Pharmacy Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Online Pharmacy',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  )),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) =>
                                            GetIt.instance<ProductCubit>(),
                                        child: const ProductPage(),
                                      ),
                                    ),
                                  );
                                },
                                child: Text('See All',
                                    style: TextStyle(
                                        color: const Color(0xFF3B82F6),
                                        fontSize: 14.sp)),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          SizedBox(
                            height: 180.h,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _buildPharmacyCard(
                                  'مسكنات الألم',
                                  'https://img.freepik.com/free-photo/medicine-capsules-global-health-with-geometric-pattern-digital-remix_53876-126742.jpg',
                                  'خصم 20%',
                                  'من 150 ج.م',
                                ),
                                _buildPharmacyCard(
                                  'فيتامينات',
                                  'https://img.freepik.com/free-photo/vitamin-bottle-with-pills_23-2148511023.jpg',
                                  'خصم 15%',
                                  'من 250 ج.م',
                                ),
                                _buildPharmacyCard(
                                  'إسعافات أولية',
                                  'https://img.freepik.com/free-photo/first-aid-kit-with-bandages-medicine_23-2148511019.jpg',
                                  'خصم 10%',
                                  'من 300 ج.م',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 32.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _modernBottomNav(context),
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
          padding: EdgeInsets.only(right: 20.w),
          child: Column(
            children: [
              CircleAvatar(
                radius: 32.r,
                backgroundColor: Colors.white,
                child: Icon(icon, color: const Color(0xFF3B82F6), size: 32.sp),
              ),
              SizedBox(height: 12.h),
              Text(label,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _doctorCard(RecommendationDoctor doctor) {
    print('Doctor profile pic: ${doctor.profilePic}'); // Debug log
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
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
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
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
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ColorsManager.primary.withOpacity(0.1),
                      ColorsManager.secondary.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: doctor.profilePic != null
                      ? CachedNetworkImage(
                          imageUrl: doctor.profilePic!.startsWith('http')
                              ? doctor.profilePic!
                              : 'http://medlink.runasp.net${doctor.profilePic}',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  ColorsManager.primary),
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            print('Error loading image: $error'); // Debug log
                            return Icon(
                              Icons.person,
                              size: 40.w,
                              color: ColorsManager.primary,
                            );
                          },
                        )
                      : Icon(
                          Icons.person,
                          size: 40.w,
                          color: ColorsManager.primary,
                        ),
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
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      doctor.speciality,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16.w,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          doctor.rate?.toStringAsFixed(1) ?? '0.0',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modernBottomNav(BuildContext context) {
    return Builder(
      builder: (BuildContext context) => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.home_rounded,
                    color: const Color(0xFF3B82F6), size: 30.sp),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DosagePredictionScreen(),
                      ),
                    );
                  },
                  child: Icon(Icons.smart_toy_rounded,
                      color: Colors.grey, size: 28.sp),
                ),
                SizedBox(width: 36.sp), // Placeholder for search icon
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentPage(),
                      ),
                    );
                  },
                  child:
                      Icon(Icons.event_note, color: Colors.grey, size: 28.sp),
                ),
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PatientProfilePage(),
                      ),
                    );
                    // Refresh profile data if returning from edit
                    if (result == true) {
                      context.read<PatientProfileCubit>().loadProfile();
                    }
                  },
                  child: Icon(Icons.person_rounded,
                      color: Colors.grey, size: 28.sp),
                ),
              ],
            ),
          ),
          Positioned(
            top: -24.h,
            child: Builder(
              builder: (BuildContext context) => GestureDetector(
                onTap: () {
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
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF3B82F6).withOpacity(0.15),
                        const Color(0xFF60A5FA).withOpacity(0.15),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                      const BoxShadow(
                        color: Colors.white,
                        blurRadius: 8,
                        offset: Offset(0, -4),
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFF3B82F6).withOpacity(0.15),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.search_rounded,
                    color: const Color(0xFF3B82F6),
                    size: 36.sp,
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
                    color: const Color(0xFF3B82F6).withOpacity(0.3),
                  )
                  .then()
                  .shake(
                    hz: 4,
                    curve: Curves.easeInOut,
                    duration: 1000.ms,
                  ),
            ),
          )
        ],
      ),
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

  Widget _buildPharmacyCard(
      String title, String imageUrl, String discount, String price) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => GetIt.instance<ProductCubit>(),
              child: const ProductPage(),
            ),
          ),
        );
      },
      child: Container(
        width: 280.w,
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorsManager.primary.withOpacity(0.1),
              ColorsManager.secondary.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.primary.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              right: -20.w,
              top: -20.h,
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorsManager.primary.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              left: -30.w,
              bottom: -30.h,
              child: Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorsManager.secondary.withOpacity(0.1),
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  // Image
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: ColorsManager.primary.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.medical_services_rounded,
                              size: 36.sp,
                              color: Colors.grey[400],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorsManager.textDark,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: ColorsManager.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            discount,
                            style: TextStyle(
                              color: ColorsManager.primary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorsManager.textMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Shop now button
            Positioned(
              bottom: 16.h,
              right: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: ColorsManager.primary,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: ColorsManager.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'تسوق الآن',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.2);
  }
}

class AutoScrollDoctorList extends StatefulWidget {
  final List<RecommendationDoctor> doctors;

  const AutoScrollDoctorList({
    super.key,
    required this.doctors,
  });

  @override
  State<AutoScrollDoctorList> createState() => _AutoScrollDoctorListState();
}

class _AutoScrollDoctorListState extends State<AutoScrollDoctorList> {
  final PageController _pageController = PageController();
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        if (_currentPage < 4) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.h,
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: widget.doctors.take(5).length,
        itemBuilder: (context, index) {
          final doctor = widget.doctors[index];
          return _buildDoctorCard(doctor);
        },
      ),
    );
  }

  Widget _buildDoctorCard(RecommendationDoctor doctor) {
    print(
        'AutoScrollDoctorList - Doctor profile pic: ${doctor.profilePic}'); // Debug log
    return GestureDetector(
      onTap: () {
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
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorsManager.primary.withOpacity(0.1),
              ColorsManager.secondary.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.primary.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative background elements
            Positioned(
              right: -30.w,
              top: -30.h,
              child: Container(
                width: 150.w,
                height: 150.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorsManager.primary.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              left: -20.w,
              bottom: -20.h,
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorsManager.secondary.withOpacity(0.1),
                ),
              ),
            ),
            // Main content
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  // Enhanced Profile Picture Section
                  Stack(
                    children: [
                      // Bottom shadow layer
                      Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(0.05)
                          ..translate(0.0, 8.0, 0.0),
                        alignment: Alignment.center,
                        child: Container(
                          width: 130.w,
                          height: 130.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
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
                          ..translate(0.0, 4.0, 0.0),
                        alignment: Alignment.center,
                        child: Container(
                          width: 130.w,
                          height: 130.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.r),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                ColorsManager.primary.withOpacity(0.2),
                                ColorsManager.secondary.withOpacity(0.2),
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
                          width: 130.w,
                          height: 130.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow: [
                              BoxShadow(
                                color: ColorsManager.primary.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                                spreadRadius: 2,
                              ),
                              const BoxShadow(
                                color: Colors.white,
                                blurRadius: 12,
                                offset: Offset(-6, -6),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24.r),
                            child: doctor.profilePic != null
                                ? CachedNetworkImage(
                                    imageUrl: doctor.profilePic!
                                            .startsWith('http')
                                        ? doctor.profilePic!
                                        : 'http://medlink.runasp.net${doctor.profilePic}',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            ColorsManager.primary
                                                .withOpacity(0.1),
                                            ColorsManager.secondary
                                                .withOpacity(0.1),
                                          ],
                                        ),
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  ColorsManager.primary),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) {
                                      print(
                                          'Error loading image: $error'); // Debug log
                                      return Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              ColorsManager.primary
                                                  .withOpacity(0.1),
                                              ColorsManager.secondary
                                                  .withOpacity(0.1),
                                            ],
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          size: 70.w,
                                          color: ColorsManager.primary,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          ColorsManager.primary
                                              .withOpacity(0.1),
                                          ColorsManager.secondary
                                              .withOpacity(0.1),
                                        ],
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      size: 70.w,
                                      color: ColorsManager.primary,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 20.w),
                  // Doctor Information Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Dr. ${doctor.firstName} ${doctor.lastName}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                            color: ColorsManager.textDark,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: ColorsManager.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            doctor.speciality,
                            style: TextStyle(
                              color: ColorsManager.primary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 20.sp,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              doctor.rate?.toString() ?? 'N/A',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                color: ColorsManager.textDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildSpecialityCard(String title, String imageUrl) {
  return Container(
    width: 100.w,
    margin: EdgeInsets.only(right: 16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: [
        BoxShadow(
          color: ColorsManager.primary.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60.w,
          height: 60.w,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: ColorsManager.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.medical_services_rounded,
                size: 24.sp,
                color: ColorsManager.primary,
              );
            },
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: ColorsManager.textDark,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.2);
}

Widget _buildSpecialitiesSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'التخصصات',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: ColorsManager.textDark,
              ),
            ),
            TextButton(
              onPressed: () {
                // Handle view all
              },
              child: Text(
                'عرض الكل',
                style: TextStyle(
                  color: ColorsManager.primary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 16.h),
      SizedBox(
        height: 120.h,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          scrollDirection: Axis.horizontal,
          children: [
            _buildSpecialityCard(
              'طب عام',
              'https://img.icons8.com/color/96/000000/stethoscope.png',
            ),
            _buildSpecialityCard(
              'طب أسنان',
              'https://img.icons8.com/color/96/000000/dental-braces.png',
            ),
            _buildSpecialityCard(
              'طب عيون',
              'https://img.icons8.com/color/96/000000/eye.png',
            ),
            _buildSpecialityCard(
              'طب أطفال',
              'https://img.icons8.com/color/96/000000/baby.png',
            ),
            _buildSpecialityCard(
              'طب نساء',
              'https://img.icons8.com/color/96/000000/pregnant.png',
            ),
          ],
        ),
      ),
    ],
  );
}
