import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/helper/shared_pref_helper.dart';
import '../../core/routes/page_routes_name.dart';
import '../../core/utils/color_manger.dart';
import '../auth/doctor/sign_in_doctor/presentation/manager/auth_cubit.dart';
import '../auth/doctor/sign_in_doctor/presentation/manager/auth_state.dart';
import '../auth/patient/sign_in/presentation/manager/auth_cubit.dart';
import '../auth/patient/sign_in/presentation/manager/auth_state.dart';

class ToggleScreen extends StatefulWidget {
  const ToggleScreen({Key? key}) : super(key: key);

  @override
  State<ToggleScreen> createState() => _ToggleScreenState();
}

class _ToggleScreenState extends State<ToggleScreen> {
  bool? isDoctor; // لتحديد ما إذا كان المستخدم طبيبًا أو مريضًا

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
      // التحقق من نوع المستخدم أولًا
      isDoctor = await SharedPrefHelper.getBool("is_doctor");
      _checkAuth();
    }
  }

  void _checkAuth() {
    if (isDoctor == null) return; // في حالة لم يتم تحديد النوع بعد

    if (isDoctor!) {
      // المستخدم طبيب
      final authState = context.read<AuthDoctorCubit>().state;
      if (authState is AuthDoctorInitial) {
        context.read<AuthDoctorCubit>().checkAuthStatus();
      }
    } else {
      // المستخدم مريض
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
                Navigator.of(context).pushReplacementNamed(PageRouteNames.patienthome);
              } else if (state is AuthUnauthenticated) {
                Navigator.of(context).pushReplacementNamed(PageRouteNames.sign_in_patient);
              }
            },
          ),
          BlocListener<AuthDoctorCubit, AuthDoctorState>(
            listener: (context, state) {
              if (state is AuthDoctorAuthenticated) {
                Navigator.of(context).pushReplacementNamed(PageRouteNames.doctorhome);
              } else if (state is AuthDoctorUnauthenticated) {
                Navigator.of(context).pushReplacementNamed(PageRouteNames.sign_in_doctor);
              }
            },
          ),
        ],
        child: Center(
          child: CircularProgressIndicator(color: ColorsManager.mainBlue),
        ),
      ),
    );
  }
}
