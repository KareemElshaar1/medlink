// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:medlink/core/theme/app_colors.dart';
// import 'package:medlink/feature/doctor/profile/data/models/doctor_profile_model.dart';

// class WelcomeCardWidget extends StatelessWidget {
//   final DoctorProfileModel? doctorProfile;

//   const WelcomeCardWidget({
//     super.key,
//     this.doctorProfile,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final String fullName = doctorProfile != null
//         ? '${doctorProfile!.firstName} ${doctorProfile!.lastName}'
//         : 'Loading...';

//     return Container(
//       padding: EdgeInsets.all(20.r),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             AppColors.primaryColor,
//             AppColors.secondaryColor,
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           stops: const [0.3, 1.0],
//         ),
//         borderRadius: BorderRadius.circular(20.r),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primaryColor.withOpacity(0.3),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Container(
//                 //   padding:
//                 //       EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
//                 //   decoration: BoxDecoration(
//                 //     color: Colors.white.withOpacity(0.2),
//                 //     borderRadius: BorderRadius.circular(20.r),
//                 //   ),
//                 //   child: Text(
//                 //     '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
//                 //     style: TextStyle(
//                 //       color: Colors.white,
//                 //       fontSize: 12.sp,
//                 //     ),
//                 //   ),
//                 // ),
//                 // SizedBox(height: 12.h),
//                 Text(
//                   'Welcome Back',
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.9),
//                     fontSize: 16.sp,
//                   ),
//                 ),
//                 SizedBox(height: 4.h),
//                 Text(
//                   fullName,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.all(16.r),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.medical_services_rounded,
//               size: 40.sp,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
