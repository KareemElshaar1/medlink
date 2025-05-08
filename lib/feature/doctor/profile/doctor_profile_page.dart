// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:medlink/core/theme/app_colors.dart';
// import 'package:animate_do/animate_do.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dio/dio.dart';
// import 'package:medlink/core/interceptors/auth_interceptor.dart';
// import 'package:medlink/feature/doctor/profile/data/repositories/doctor_profile_repository.dart';
// import 'package:medlink/feature/doctor/profile/data/models/doctor_profile_model.dart';
// import 'package:medlink/core/routes/page_routes_name.dart';
//
// class DoctorProfilePage extends StatefulWidget {
//   const DoctorProfilePage({super.key});
//
//   @override
//   State<DoctorProfilePage> createState() => _DoctorProfilePageState();
// }
//
// class _DoctorProfilePageState extends State<DoctorProfilePage> {
//   final _repository =
//       DoctorProfileRepositoryImpl(Dio()..interceptors.add(AuthInterceptor()));
//   bool _isLoading = true;
//   DoctorProfileModel? _profileData;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchDoctorProfile();
//   }
//
//   Future<void> _fetchDoctorProfile() async {
//     try {
//       final profile = await _repository.getDoctorProfile();
//       setState(() {
//         _profileData = profile;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error loading profile: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               AppColors.primaryColor.withOpacity(0.1),
//               Colors.white,
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: _isLoading
//               ? Center(
//                   child: CircularProgressIndicator(
//                     color: AppColors.primaryColor,
//                   ),
//                 )
//               : SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildAppBar(context),
//                       Padding(
//                         padding: EdgeInsets.all(16.r),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             FadeInDown(
//                               duration: const Duration(milliseconds: 500),
//                               child: _buildProfileHeader(),
//                             ),
//                             SizedBox(height: 24.h),
//                             FadeInDown(
//                               duration: const Duration(milliseconds: 600),
//                               child: _buildProfileInfo(),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAppBar(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: 16.w,
//         vertical: 4.h,
//       ),
//       height: 80.h,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             AppColors.primaryColor,
//             AppColors.secondaryColor,
//           ],
//         ),
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(25.r),
//           bottomRight: Radius.circular(25.r),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primaryColor.withOpacity(0.3),
//             blurRadius: 15,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Row(
//           children: [
//             Container(
//               width: 40.w,
//               height: 40.h,
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(10.r),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 8,
//                     spreadRadius: 1,
//                   ),
//                 ],
//               ),
//               child: IconButton(
//                 padding: EdgeInsets.zero,
//                 onPressed: () => Navigator.pop(context),
//                 icon: Icon(
//                   Icons.arrow_back_rounded,
//                   color: Colors.white,
//                   size: 22.sp,
//                 ),
//               ),
//             ),
//             SizedBox(width: 12.w),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'My Profile',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 22.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 2.h),
//                   Text(
//                     'Manage your account settings',
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.9),
//                       fontSize: 13.sp,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               width: 40.w,
//               height: 40.h,
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 8,
//                     spreadRadius: 1,
//                   ),
//                 ],
//               ),
//               child: IconButton(
//                 padding: EdgeInsets.zero,
//                 onPressed: () {
//                   Navigator.pushNamed(
//                     context,
//                     PageRouteNames.editProfile,
//                     arguments: _profileData,
//                   );
//                 },
//                 icon: Icon(
//                   Icons.edit_rounded,
//                   color: Colors.white,
//                   size: 22.sp,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileHeader() {
//     final String fullName = _profileData != null
//         ? '${_profileData!.firstName} ${_profileData!.lastName}'
//         : 'Loading...';
//     final String profilePicUrl = _profileData?.profilePic != null
//         ? 'http://medlink.runasp.net${_profileData!.profilePic}'
//         : '';
//
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(24.r),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24.r),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primaryColor.withOpacity(0.1),
//             blurRadius: 20,
//             spreadRadius: 0,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(4.r),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: AppColors.primaryColor,
//                     width: 2,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColors.primaryColor.withOpacity(0.2),
//                       blurRadius: 20,
//                       spreadRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: CircleAvatar(
//                   radius: 60.r,
//                   backgroundColor: Colors.white,
//                   child: profilePicUrl.isNotEmpty
//                       ? ClipOval(
//                           child: CachedNetworkImage(
//                             imageUrl: profilePicUrl,
//                             fit: BoxFit.cover,
//                             width: 120.r,
//                             height: 120.r,
//                             placeholder: (context, url) => Icon(
//                               Icons.person_rounded,
//                               size: 70.sp,
//                               color: AppColors.primaryColor,
//                             ),
//                             errorWidget: (context, url, error) => Icon(
//                               Icons.person_rounded,
//                               size: 70.sp,
//                               color: AppColors.primaryColor,
//                             ),
//                           ),
//                         )
//                       : Icon(
//                           Icons.person_rounded,
//                           size: 70.sp,
//                           color: AppColors.primaryColor,
//                         ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 20.h),
//           Text(
//             fullName,
//             style: TextStyle(
//               color: AppColors.textColor,
//               fontSize: 28.sp,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 8.h),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
//             decoration: BoxDecoration(
//               color: AppColors.primaryColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(20.r),
//             ),
//             child: Text(
//               _profileData?.about ?? 'Doctor',
//               style: TextStyle(
//                 color: AppColors.primaryColor,
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProfileInfo() {
//     return Container(
//       padding: EdgeInsets.all(24.r),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24.r),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primaryColor.withOpacity(0.1),
//             blurRadius: 20,
//             spreadRadius: 0,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.person_outline_rounded,
//                 color: AppColors.primaryColor,
//                 size: 24.sp,
//               ),
//               SizedBox(width: 12.w),
//               Text(
//                 'Personal Information',
//                 style: TextStyle(
//                   color: AppColors.textColor,
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 24.h),
//           _buildInfoItem(
//             icon: Icons.email_rounded,
//             title: 'Email',
//             value: _profileData?.email ?? '',
//           ),
//           _buildInfoItem(
//             icon: Icons.phone_rounded,
//             title: 'Phone',
//             value: _profileData?.phone ?? '',
//           ),
//           _buildInfoItem(
//             icon: Icons.info_rounded,
//             title: 'About',
//             value: _profileData?.about ?? '',
//           ),
//           if (_profileData?.rate != null)
//             _buildInfoItem(
//               icon: Icons.star_rounded,
//               title: 'Rating',
//               value: _profileData!.rate.toString(),
//               iconColor: Colors.amber,
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoItem({
//     required IconData icon,
//     required String title,
//     required String value,
//     Color? iconColor,
//   }) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 20.h),
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(12.r),
//             decoration: BoxDecoration(
//               color: (iconColor ?? AppColors.primaryColor).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               color: iconColor ?? AppColors.primaryColor,
//               size: 24.sp,
//             ),
//           ),
//           SizedBox(width: 16.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: AppColors.greyColor,
//                     fontSize: 14.sp,
//                   ),
//                 ),
//                 SizedBox(height: 4.h),
//                 Text(
//                   value,
//                   style: TextStyle(
//                     color: AppColors.textColor,
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
