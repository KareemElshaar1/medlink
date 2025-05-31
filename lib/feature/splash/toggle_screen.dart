import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medlink/core/theme/app_colors.dart';

import '../../core/helper/shared_pref_helper.dart';
import '../../core/routes/page_routes_name.dart';
import '../../core/utils/color_manger.dart';
import '../auth/doctor/sign_in_doctor/presentation/manager/auth_cubit.dart';
import '../auth/doctor/sign_in_doctor/presentation/manager/auth_state.dart';
import '../auth/patient/sign_in/presentation/manager/auth_cubit.dart';
import '../auth/patient/sign_in/presentation/manager/auth_state.dart';

class ToggleScreen extends StatefulWidget {
  const ToggleScreen({super.key});

  @override
  State<ToggleScreen> createState() => _ToggleScreenState();
}

class _ToggleScreenState extends State<ToggleScreen> {
  bool? isDoctor;

  @override
  void initState() {
    super.initState();
    _checkFirstTimeAndAuth();
  }

  Future<void> _checkFirstTimeAndAuth() async {
    bool isFirstTime = await SharedPrefHelper.getBool("first_time");

    if (isFirstTime) {
      Navigator.of(context).pushReplacementNamed(PageRouteNames.onboarding);
    } else {
      // Check both user types
      bool isPatient = await SharedPrefHelper.getBool("is_patient");
      bool isDoctorUser = await SharedPrefHelper.getBool("is_doctor");

      // If both are true or both are false, we have an invalid state
      if (isPatient == isDoctorUser) {
        // Clear both states and go to selection screen
        await SharedPrefHelper.removeData("is_patient");
        await SharedPrefHelper.removeData("is_doctor");
        Navigator.of(context).pushReplacementNamed(PageRouteNames.SelectScreen);
        return;
      }

      isDoctor = isDoctorUser;
      _checkAuth();
    }
  }

  void _checkAuth() {
    if (isDoctor == null) return;

    if (isDoctor!) {
      final authState = context.read<AuthDoctorCubit>().state;
      if (authState is AuthDoctorInitial) {
        context.read<AuthDoctorCubit>().checkAuthStatus();
      }
    } else {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthInitial) {
        context.read<AuthCubit>().checkAuthStatus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                Navigator.of(context)
                    .pushReplacementNamed(PageRouteNames.patienthome);
              } else if (state is AuthUnauthenticated) {
                Navigator.of(context)
                    .pushReplacementNamed(PageRouteNames.SelectScreen);
              }
            },
          ),
          BlocListener<AuthDoctorCubit, AuthDoctorState>(
            listener: (context, state) {
              if (state is AuthDoctorAuthenticated) {
                Navigator.of(context)
                    .pushReplacementNamed(PageRouteNames.doctorhome);
              } else if (state is AuthDoctorUnauthenticated) {
                Navigator.of(context)
                    .pushReplacementNamed(PageRouteNames.SelectScreen);
              }
            },
          ),
        ],
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
    );
  }
}
