import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:medlink/feature/Selection/widgets/role_selection_button.dart';

import '../../core/routes/page_routes_name.dart';

class SelectScreen extends StatelessWidget {
  const SelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade100,
              Colors.blue.shade200,
              Colors.teal.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Improved Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "MedLink",
                      style: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2D3E50),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Gap(8.h),
                    Text(
                      "Choose Your Healthcare Path",
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.blueGrey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // Main content - buttons
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Doctor Button with enhanced styling
                        RoleSelectionButton(
                          title: "Doctor",
                          subtitle: "Healthcare Professional Access",
                          primaryColor: const Color(0xFF1E88E5),
                          shadowColor: Colors.blue.shade300,
                          iconData: Icons.medical_services_rounded,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Doctor login selected"),
                                backgroundColor: Colors.blue,
                              ),
                            );
                            Navigator.of(context).pushNamed(PageRouteNames.sign_in_doctor);
                          },
                        ),

                        Gap(24.h),

                        // Patient Button with enhanced styling
                        RoleSelectionButton(
                          title: "Patient",
                          subtitle: "Personal Health Portal",
                          primaryColor: const Color(0xFF26A69A),
                          shadowColor: Colors.teal.shade200,
                          iconData: Icons.person_rounded,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Patient login selected"),
                                backgroundColor: Colors.teal,
                              ),
                            );
                            Navigator.of(context).pushNamed(PageRouteNames.sign_in_patient);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Improved Footer
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.shade300,
                          Colors.red.shade400,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.shade200.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Emergency/guest access logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Connecting to Emergency Services"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        "Emergency? Get Immediate Assistance",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}