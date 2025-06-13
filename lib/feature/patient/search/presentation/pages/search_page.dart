import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:flutter_animate/flutter_animate.dart';
import '../cubit/search_cubit.dart';
import '../../data/models/doctor_model.dart';
import '../../../doctors_by_specialty/presentation/pages/doctor_details_page.dart';
import '../../../doctors_by_specialty/data/models/doctor_by_specialty_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _debounce = Debouncer(milliseconds: 500);
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Search Bar
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFF3B82F6),
                          size: 24.sp,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F8FA),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Color(0xFF3B82F6).withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search doctors...',
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: Color(0xFF3B82F6),
                                size: 24.sp,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 15.sp,
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15.sp,
                            ),
                            onChanged: (query) {
                              _debounce.run(() {
                                context
                                    .read<SearchCubit>()
                                    .searchDoctors(query);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Search Results
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_rounded,
                            size: 64.sp,
                            color: Color(0xFF3B82F6).withOpacity(0.5),
                          ).animate().fadeIn(duration: 600.ms).scale(
                                begin: const Offset(0.8, 0.8),
                                duration: 600.ms,
                                curve: Curves.easeOutBack,
                              ),
                          SizedBox(height: 16.h),
                          Text(
                            'Start typing to search doctors',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 200.ms)
                              .slideY(begin: 0.3, end: 0),
                        ],
                      ),
                    );
                  }

                  if (state is SearchLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                      ).animate().fadeIn(duration: 300.ms).scale(
                            begin: const Offset(0.8, 0.8),
                            duration: 300.ms,
                          ),
                    );
                  }

                  if (state is SearchError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 64.sp,
                            color: Colors.red.withOpacity(0.5),
                          ).animate().fadeIn(duration: 600.ms).scale(
                                begin: const Offset(0.8, 0.8),
                                duration: 600.ms,
                                curve: Curves.easeOutBack,
                              ),
                          SizedBox(height: 16.h),
                          Text(
                            state.message,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          )
                              .animate()
                              .fadeIn(delay: 200.ms)
                              .slideY(begin: 0.3, end: 0),
                        ],
                      ),
                    );
                  }

                  if (state is SearchSuccess) {
                    if (state.doctors.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 64.sp,
                              color: Colors.grey[400],
                            ).animate().fadeIn(duration: 600.ms).scale(
                                  begin: const Offset(0.8, 0.8),
                                  duration: 600.ms,
                                  curve: Curves.easeOutBack,
                                ),
                            SizedBox(height: 16.h),
                            Text(
                              'No doctors found',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey[600],
                              ),
                            )
                                .animate()
                                .fadeIn(delay: 200.ms)
                                .slideY(begin: 0.3, end: 0),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      itemCount: state.doctors.length,
                      itemBuilder: (context, index) {
                        final doctor = state.doctors[index];
                        return _buildDoctorCard(doctor)
                            .animate()
                            .fadeIn(
                              delay: Duration(milliseconds: 100 * index),
                              duration: 600.ms,
                            )
                            .slideX(
                              begin: 0.2,
                              end: 0,
                              delay: Duration(milliseconds: 100 * index),
                              duration: 600.ms,
                              curve: Curves.easeOutQuart,
                            );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(DoctorModel doctor) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
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
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  width: 70.w,
                  height: 70.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF3B82F6).withOpacity(0.1),
                        Color(0xFF60A5FA).withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: doctor.profilePic != null
                        ? Image.network(
                            'http://medlink.runasp.net${doctor.profilePic}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person_rounded,
                                size: 32.sp,
                                color: Color(0xFF3B82F6),
                              );
                            },
                          )
                        : Icon(
                            Icons.person_rounded,
                            size: 32.sp,
                            color: Color(0xFF3B82F6),
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
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF3B82F6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          doctor.speciality,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Color(0xFF3B82F6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (doctor.about != null) ...[
                        SizedBox(height: 8.h),
                        Text(
                          doctor.about!,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 16.sp,
                            color: Colors.amber,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            doctor.rate?.toString() ?? 'N/A',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.sp,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
