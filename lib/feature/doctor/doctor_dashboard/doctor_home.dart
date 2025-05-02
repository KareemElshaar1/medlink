import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medlink/core/routes/page_routes_name.dart';
import 'package:medlink/core/utils/app_text_style.dart';
import 'package:medlink/core/theme/app_colors.dart';
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

class DrawerItem {
  final String title;
  final IconData icon;
  final String route;
  final Color color;
  final List<DrawerSubItem>? subItems;

  DrawerItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.color,
    this.subItems,
  });
}

class DrawerSubItem {
  final String title;
  final String route;
  final IconData icon;

  DrawerSubItem({
    required this.title,
    required this.route,
    required this.icon,
  });
}

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
      route: '/appointments',
      color: Colors.purple,
      subItems: [
        DrawerSubItem(
          title: 'Today\'s Schedule',
          route: '/appointments/today',
          icon: Icons.today_rounded,
        ),
        DrawerSubItem(
          title: 'Upcoming',
          route: '/appointments/upcoming',
          icon: Icons.upcoming_rounded,
        ),
        DrawerSubItem(
          title: 'Past Appointments',
          route: '/appointments/past',
          icon: Icons.history_rounded,
        ),
      ],
    ),
    DrawerItem(
      title: 'Patient Records',
      icon: Icons.medical_services_rounded,
      route: '/patients',
      color: Colors.green,
      subItems: [
        DrawerSubItem(
          title: 'All Patients',
          route: '/patients/all',
          icon: Icons.people_alt_rounded,
        ),
        DrawerSubItem(
          title: 'Recent Patients',
          route: '/patients/recent',
          icon: Icons.recent_actors_rounded,
        ),
        DrawerSubItem(
          title: 'Patient History',
          route: '/patients/history',
          icon: Icons.history_rounded,
        ),
      ],
    ),
    DrawerItem(
      title: 'Prescriptions',
      icon: Icons.medication_rounded,
      route: '/prescriptions',
      color: Colors.orange,
      subItems: [
        DrawerSubItem(
          title: 'New Prescription',
          route: '/prescriptions/new',
          icon: Icons.add_circle_rounded,
        ),
        DrawerSubItem(
          title: 'Prescription History',
          route: '/prescriptions/history',
          icon: Icons.history_rounded,
        ),
      ],
    ),
    DrawerItem(
      title: 'Medical Reports',
      icon: Icons.assignment_rounded,
      route: '/reports',
      color: Colors.pink,
      subItems: [
        DrawerSubItem(
          title: 'Create Report',
          route: '/reports/create',
          icon: Icons.add_circle_rounded,
        ),
        DrawerSubItem(
          title: 'View Reports',
          route: '/reports/view',
          icon: Icons.visibility_rounded,
        ),
      ],
    ),
    DrawerItem(
      title: 'My Clinics',
      icon: Icons.local_hospital_rounded,
      route: PageRouteNames.clinicList,
      color: Colors.teal,
    ),
    DrawerItem(
      title: 'Consultations',
      icon: Icons.video_call_rounded,
      route: '/consultations',
      color: Colors.indigo,
      subItems: [
        DrawerSubItem(
          title: 'Start Consultation',
          route: '/consultations/start',
          icon: Icons.video_call_rounded,
        ),
        DrawerSubItem(
          title: 'Consultation History',
          route: '/consultations/history',
          icon: Icons.history_rounded,
        ),
      ],
    ),
    DrawerItem(
      title: 'Earnings',
      icon: Icons.payments_rounded,
      route: '/earnings',
      color: Colors.amber,
      subItems: [
        DrawerSubItem(
          title: 'Today\'s Earnings',
          route: '/earnings/today',
          icon: Icons.today_rounded,
        ),
        DrawerSubItem(
          title: 'Monthly Report',
          route: '/earnings/monthly',
          icon: Icons.calendar_month_rounded,
        ),
      ],
    ),
    DrawerItem(
      title: 'Profile',
      icon: Icons.person_rounded,
      route: '/profile',
      color: Colors.deepPurple,
    ),
    DrawerItem(
      title: 'Settings',
      icon: Icons.settings_rounded,
      route: '/settings',
      color: Colors.grey,
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
          Navigator.of(context)
              .pushReplacementNamed(PageRouteNames.sign_in_doctor);
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
                  AppColors.backgroundColor,
                  AppColors.secondaryColor.withOpacity(0.05),
                ],
              ),
            ),
            child: _isLoading ? _buildLoadingState() : _buildDashboardContent(),
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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor,
              AppColors.secondaryColor,
            ],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.r),
            bottomRight: Radius.circular(30.r),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.3),
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
            _buildDrawerHeader(),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: _drawerItems.length,
                itemBuilder: (context, index) {
                  final item = _drawerItems[index];
                  return _buildDrawerItem(item, index);
                },
              ),
            ),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    final String fullName = _isLoading
        ? 'Loading...'
        : _doctorProfile != null
            ? '${_doctorProfile!.firstName} ${_doctorProfile!.lastName}'
            : 'Not Available';

    final String profilePicUrl = _doctorProfile?.profilePic != null
        ? 'http://medlink.runasp.net${_doctorProfile!.profilePic}'
        : '';

    return Container(
      height: 220.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            AppColors.secondaryColor,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 45.r,
                backgroundColor: Colors.white,
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: AppColors.primaryColor,
                        strokeWidth: 3,
                      )
                    : profilePicUrl.isNotEmpty
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: profilePicUrl,
                              fit: BoxFit.cover,
                              width: 90.r,
                              height: 90.r,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(
                                color: AppColors.primaryColor,
                                strokeWidth: 3,
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.person_rounded,
                                size: 50.sp,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.person_rounded,
                            size: 50.sp,
                            color: AppColors.primaryColor,
                          ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              fullName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(DrawerItem item, int index) {
    final isSelected = _selectedIndex == index;
    final isExpanded = _expandedItems[index] ?? false;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.blueAccent.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: InkWell(
            onTap: () {
              if (item.subItems != null) {
                setState(() {
                  _expandedItems[index] = !isExpanded;
                });
              } else {
                setState(() {
                  _selectedIndex = index;
                });
                Navigator.pop(context);
                _handleNavigation(item);
              }
            },
            borderRadius: BorderRadius.circular(15.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                children: [
                  SizedBox(width: 16.w),
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? item.color.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.icon,
                      color: isSelected ? item.color : Colors.grey,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        color: isSelected ? item.color : Colors.black87,
                        fontSize: 16.sp,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (item.subItems != null)
                    Icon(
                      isExpanded
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      color: isSelected ? item.color : Colors.grey,
                    )
                  else if (isSelected)
                    Container(
                      height: 24.h,
                      width: 4.w,
                      decoration: BoxDecoration(
                        color: item.color,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  SizedBox(width: 16.w),
                ],
              ),
            ),
          ),
        ),
        if (isExpanded && item.subItems != null)
          ...item.subItems!
              .map((subItem) => _buildSubItem(subItem, item.color)),
      ],
    );
  }

  Widget _buildSubItem(DrawerSubItem subItem, Color parentColor) {
    return Container(
      margin: EdgeInsets.only(left: 32.w, right: 16.w, top: 4.h, bottom: 4.h),
      decoration: BoxDecoration(
        color: parentColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          _showComingSoonSnackBar(subItem.title);
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              SizedBox(width: 16.w),
              Icon(
                subItem.icon,
                color: parentColor,
                size: 18.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  subItem.title,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNavigation(DrawerItem item) async {
    switch (item.route) {
      case PageRouteNames.doctorhome:
        break;
      case PageRouteNames.clinicList:
        try {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => GetIt.I<ClinicCubit>(),
                child: const ClinicListPage(),
              ),
            ),
          );
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
        backgroundColor: AppColors.primaryColor,
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
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                'Are you sure you want to logout?',
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.greyColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<AuthDoctorCubit>().logout();
                    Navigator.of(
                      context,
                    ).pushReplacementNamed(PageRouteNames.sign_in_doctor);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.withOpacity(0.1),
          foregroundColor: Colors.red,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        icon: Icon(Icons.logout_rounded, size: 20.sp),
        label: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            'Logout',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Loading Dashboard...',
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1000),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            SizedBox(height: 24.h),
            _buildStatsSection(),
            SizedBox(height: 24.h),
            _buildAppointmentsSection(),
            SizedBox(height: 24.h),
            _buildRecentPatientsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    final String fullName = _doctorProfile != null
        ? '${_doctorProfile!.firstName} ${_doctorProfile!.lastName}'
        : 'Loading...';

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.secondaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.3, 1.0],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Welcome Back,',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  fullName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.medical_services_rounded,
              size: 40.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Statistics',
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard(
                icon: Icons.calendar_today_rounded,
                iconColor: Colors.blue,
                iconBgColor: Colors.blue.withOpacity(0.1),
                value: '0',
                label: 'Today\'s\nAppointments',
              ),
              _buildStatCard(
                icon: Icons.people_alt_rounded,
                iconColor: Colors.purple,
                iconBgColor: Colors.purple.withOpacity(0.1),
                value: '0',
                label: 'Total\nPatients',
              ),
              _buildStatCard(
                icon: Icons.star_rounded,
                iconColor: Colors.amber,
                iconBgColor: Colors.amber.withOpacity(0.1),
                value: '0.0',
                label: 'Rating',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String value,
    required String label,
  }) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.greyColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20.sp,
              color: iconColor,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: AppColors.greyColor,
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Appointments',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  size: 18.sp,
                  color: AppColors.primaryColor,
                ),
                label: Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.greyColor.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  size: 32.sp,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'No appointments scheduled',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'You have no appointments for today',
                style: TextStyle(
                  color: AppColors.greyColor,
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'Create Appointment',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentPatientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Patients',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  size: 18.sp,
                  color: AppColors.primaryColor,
                ),
                label: Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.greyColor.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.people_alt_rounded,
                  size: 32.sp,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'No recent patients',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Your recent patients will appear here',
                style: TextStyle(
                  color: AppColors.greyColor,
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primaryColor),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'View All Patients',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
