import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medlink/core/routes/page_routes_name.dart';
import 'package:medlink/core/utils/color_manger.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medlink/core/interceptors/auth_interceptor.dart';
import 'package:medlink/feature/doctor/clinic/presentation/cubit/clinic_cubit.dart';
import 'package:medlink/feature/doctor/clinic/presentation/pages/clinic_list_page_fixed.dart';
import 'package:medlink/feature/auth/doctor/sign_in_doctor/presentation/manager/auth_cubit.dart';
import 'package:medlink/feature/auth/doctor/sign_in_doctor/presentation/manager/auth_state.dart';
import 'package:medlink/feature/doctor/profile/data/repositories/doctor_profile_repository.dart';
import 'package:medlink/feature/doctor/profile/data/models/doctor_profile_model.dart';
import 'package:medlink/feature/doctor/profile/data/services/doctor_profile_storage.dart';
import 'package:medlink/feature/doctor/doctor_dashboard/widgets/drawer_header_widget.dart';
import 'package:medlink/feature/doctor/doctor_dashboard/widgets/drawer_item_widget.dart';
import 'package:medlink/feature/doctor/doctor_dashboard/widgets/welcome_card_widget.dart';
import 'package:medlink/feature/doctor/doctor_dashboard/widgets/stats_section_widget.dart';
import 'package:medlink/feature/doctor/doctor_dashboard/widgets/my_patient_section.dart';
import 'package:medlink/feature/doctor/doctor_dashboard/widgets/my_schedule_section_widget.dart';
import 'package:medlink/feature/doctor/doctor_dashboard/widgets/loading_state_widget.dart';
import 'package:medlink/feature/doctor/doctor_dashboard/models/drawer_item_model.dart';
import 'package:medlink/feature/Selection/select_screen.dart';
import 'package:medlink/feature/doctor/appointments/presentation/cubit/appointment_cubit.dart';
import 'package:medlink/feature/doctor/schedule/presentation/cubit/schedule_cubit.dart';
import 'package:medlink/feature/doctor/schedule/presentation/screens/schedule_list_screen.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  final Map<int, bool> _expandedItems = {};
  DoctorProfileModel? _doctorProfile;
  final _repository =
      DoctorProfileRepositoryImpl(Dio()..interceptors.add(AuthInterceptor()));
  late final DoctorProfileStorage _storage;

  final List<DrawerItem> _drawerItems = [
    DrawerItem(
      title: 'Dashboard',
      icon: Icons.dashboard_rounded,
      route: PageRouteNames.doctorhome,
      color: Colors.blue,
    ),
    DrawerItem(
      title: 'My Schedule',
      icon: Icons.calendar_month_rounded,
      route: PageRouteNames.scheduleList,
      color: Colors.purple,
    ),
    DrawerItem(
      title: 'Appointments',
      icon: Icons.event_note_rounded,
      route: PageRouteNames.appointments,
      color: Colors.orange,
    ),
    DrawerItem(
      title: 'My Clinics',
      icon: Icons.local_hospital_rounded,
      route: PageRouteNames.clinicList,
      color: Colors.teal,
    ),
    DrawerItem(
      title: 'Profile',
      icon: Icons.person_rounded,
      route: '/profile',
      color: Colors.deepPurple,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _storage = DoctorProfileStorage();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Try to get profile from storage first
      final storedProfile = await _storage.getProfile();
      if (storedProfile != null) {
        setState(() {
          _doctorProfile = storedProfile;
          _isLoading = false;
        });
      }

      // Then fetch fresh data from API
      final profile = await _repository.getDoctorProfile();
      print('Profile loaded: ${profile.toJson()}');

      // Save to storage
      await _storage.saveProfile(profile);

      if (mounted) {
        setState(() {
          _doctorProfile = profile;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Add refresh method
  Future<void> refreshData() async {
    await _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthDoctorCubit, AuthDoctorState>(
      listener: (context, state) {
        if (state is AuthDoctorUnauthenticated) {
          //   Navigator.of(context)
          //       .pushReplacementNamed(PageRouteNames.sign_in_doctor);
        }
      },
      child: Scaffold(
        drawer: _buildDrawer(),
        appBar: _buildAppBar(),
        body: RefreshIndicator(
          onRefresh: refreshData,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorsManager.background,
                  ColorsManager.secondary.withOpacity(0.05),
                ],
              ),
            ),
            child: _isLoading
                ? const LoadingStateWidget()
                : _buildDashboardContent(),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final String fullName = _isLoading
        ? 'Loading...'
        : _doctorProfile != null
            ? '${_doctorProfile!.firstName} ${_doctorProfile!.lastName}'
            : 'Not Available';

    final String profilePicUrl = _doctorProfile?.profilePic != null
        ? 'http://medlink.runasp.net${_doctorProfile!.profilePic}'
        : '';

    return PreferredSize(
      preferredSize: Size.fromHeight(120.h),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorsManager.primary,
              ColorsManager.primaryDark,
            ],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.r),
            bottomRight: Radius.circular(30.r),
          ),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Builder(
                          builder: (context) => Container(
                            width: 45.w,
                            height: 45.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.menu_rounded,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              fullName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 45.w,
                              height: 45.h,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.notifications_rounded,
                                  color: Colors.white,
                                  size: 24.sp,
                                ),
                                onPressed: () {},
                              ),
                            ),
                            Positioned(
                              right: 6.w,
                              top: 6.h,
                              child: Container(
                                padding: EdgeInsets.all(4.r),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.4),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 20.w,
                                  minHeight: 20.h,
                                ),
                                child: Center(
                                  child: Text(
                                    '3',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, PageRouteNames.doctorProfile);
                          },
                          child: Container(
                            width: 45.w,
                            height: 45.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: profilePicUrl.isNotEmpty
                                ? ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: profilePicUrl,
                                      fit: BoxFit.cover,
                                      width: 90.r,
                                      height: 90.r,
                                      placeholder: (context, url) => Icon(
                                        Icons.person_rounded,
                                        color: Colors.white,
                                        size: 24.sp,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(
                                        Icons.person_rounded,
                                        color: Colors.white,
                                        size: 24.sp,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    Icons.person_rounded,
                                    color: Colors.white,
                                    size: 24.sp,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Builder(
        builder: (context) => Column(
          children: [
            DrawerHeaderWidget(
              isLoading: _isLoading,
              doctorProfile: _doctorProfile,
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: _drawerItems.length,
                itemBuilder: (context, index) {
                  final item = _drawerItems[index];
                  return DrawerItemWidget(
                    item: item,
                    isSelected: _selectedIndex == index,
                    isExpanded: _expandedItems[index] ?? false,
                    onTap: () {
                      if (item.subItems != null) {
                        setState(() {
                          _expandedItems[index] =
                              !(_expandedItems[index] ?? false);
                        });
                      } else {
                        setState(() {
                          _selectedIndex = index;
                        });
                        Navigator.pop(context);
                        _handleNavigation(item);
                      }
                    },
                  );
                },
              ),
            ),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(DrawerItem item) async {
    switch (item.route) {
      case PageRouteNames.doctorhome:
        break;
      case PageRouteNames.appointments:
        try {
          Navigator.pushNamed(context, PageRouteNames.appointments);
        } catch (e) {
          _showErrorSnackBar('Navigation failed: ${e.toString()}');
        }
        break;
      case PageRouteNames.clinicList:
        try {
          Navigator.pushNamed(context, PageRouteNames.clinicList);
        } catch (e) {
          _showErrorSnackBar('Navigation failed: ${e.toString()}');
        }
        break;
      case PageRouteNames.scheduleList:
        try {
          Navigator.pushNamed(context, PageRouteNames.scheduleList);
        } catch (e) {
          _showErrorSnackBar('Navigation failed: ${e.toString()}');
        }
        break;
      case '/profile':
        try {
          final result =
              await Navigator.pushNamed(context, PageRouteNames.doctorProfile);
          if (result == true) {
            refreshData();
          }
        } catch (e) {
          _showErrorSnackBar('Navigation failed: ${e.toString()}');
        }
        break;
      default:
        _showComingSoonSnackBar(item.title);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        margin: EdgeInsets.all(16.r),
      ),
    );
  }

  void _showComingSoonSnackBar(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              '$feature coming soon!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        backgroundColor: ColorsManager.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        margin: EdgeInsets.all(16.r),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: EdgeInsets.all(16.r),
      child: ElevatedButton.icon(
        onPressed: () {
          context.read<AuthDoctorCubit>().logout();
          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const SelectScreen(),
              ),
              (route) => false,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.withOpacity(0.1),
          foregroundColor: Colors.red,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
            side: BorderSide(color: Colors.red.withOpacity(0.3)),
          ),
        ),
        icon: Icon(
          Icons.logout_rounded,
          size: 20.sp,
        ),
        label: Text(
          'Logout',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1000),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GetIt.I<AppointmentCubit>()..getAppointments(),
          ),
          BlocProvider(
            create: (context) => GetIt.I<ScheduleCubit>()..getSchedule(),
          ),
        ],
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              BlocBuilder<AppointmentCubit, AppointmentState>(
                builder: (context, state) {
                  if (state is AppointmentError) {
                    return _buildErrorState();
                  }

                  if (state is AppointmentLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is AppointmentLoaded) {
                    final appointments = state.appointments;
                    final totalPatients = appointments.isEmpty
                        ? 0
                        : appointments
                            .map((appointment) => appointment.patient)
                            .toSet()
                            .length;

                    return Column(
                      children: [
                        BlocBuilder<ScheduleCubit, ScheduleState>(
                          builder: (context, scheduleState) {
                            int todaySchedules = 0;
                            if (scheduleState is SchedulesLoaded) {
                              todaySchedules = scheduleState.schedules.length;
                            }
                            return StatsSectionWidget(
                              totalPatients: totalPatients,
                              todayAppointments: todaySchedules,
                              rating:
                                  4.5, // This should come from your rating system
                            );
                          },
                        ),
                        SizedBox(height: 24.h),
                        if (appointments.isEmpty)
                          _buildEmptyState()
                        else ...[
                          const MyPatientWidget(),
                          SizedBox(height: 24.h),
                        ],
                        const MyScheduleSectionWidget(),
                      ],
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_alt_rounded,
            size: 48.sp,
            color: ColorsManager.textLight,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Patients Yet',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: ColorsManager.textDark,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your patients will appear here once they book appointments',
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorsManager.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48.sp,
            color: Colors.red,
          ),
          SizedBox(height: 16.h),
          Text(
            'Error Loading Data',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: ColorsManager.textDark,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please try refreshing the page',
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorsManager.textLight,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: refreshData,
            icon: Icon(Icons.refresh_rounded, size: 20.sp),
            label: Text(
              'Refresh',
              style: TextStyle(fontSize: 14.sp),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
