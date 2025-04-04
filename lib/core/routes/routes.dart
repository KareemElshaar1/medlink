import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medlink/core/routes/page_routes_name.dart';

import '../../di.dart';
import '../../feature/Selection/select_screen.dart';
import '../../feature/auth/doctor/sign_in_doctor/presentation/manager/auth_cubit.dart';
import '../../feature/auth/doctor/sign_in_doctor/presentation/manager/cubit/login_cubit.dart';
import '../../feature/auth/doctor/sign_in_doctor/presentation/pages/sign_in_screen.dart';
import '../../feature/auth/doctor/sign_up_doctor/presentation/manager/doctor_registration_cubit.dart';
import '../../feature/auth/doctor/sign_up_doctor/presentation/manager/specialities/specialities_cubit.dart';
import '../../feature/auth/doctor/sign_up_doctor/presentation/pages/sign_up_screen.dart';
import '../../feature/auth/patient/sign_in/presentation/manager/auth_cubit.dart';
import '../../feature/auth/patient/sign_in/presentation/manager/cubit/login_cubit.dart';
import '../../feature/auth/patient/sign_in/presentation/pages/sign_in_screen.dart';
import '../../feature/auth/patient/sign_up/presentation/manager/cubit/patient_register_cubit.dart';
import '../../feature/auth/patient/sign_up/presentation/pages/sign_up_screen.dart';
import '../../feature/onboarding/ui/on_boarding_screen.dart';
import '../../feature/splash/doctor_home.dart';
import '../../feature/splash/home_patient.dart';
 import '../../feature/splash/toggle_screen.dart';

class Routes {
  static Route onGeneratedRoute(RouteSettings settings) {
    switch (settings.name) {
      case PageRouteNames.initial:
        return _createRoute(
              (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<AuthCubit>()..checkAuthStatus()),
              BlocProvider(create: (context) => sl<AuthDoctorCubit>()..checkAuthStatus), // إضافة AuthDoctorCubit
            ],
            child: const ToggleScreen(),
          ),
          settings,
        );

      case PageRouteNames.onboarding:
        return _createRoute(
              (context) => const OnboardingScreen(),
          settings,
        );

      case PageRouteNames.sign_in_patient:
        return _createRoute(
              (context) => BlocProvider(
            create: (context) => sl<LoginCubit>(),
            child: const SignInPatient(),
          ),
          settings,
        );

      case PageRouteNames.sign_up_patient:
        return _createRoute(
              (context) => BlocProvider(
            create: (context) => sl<PatientRegistrationCubit>(),
            child: SignUpPatient(),
          ),
          settings,
        );

      case PageRouteNames.sign_in_doctor:
        return _createRoute(
              (context) => BlocProvider(
            create: (context) => sl<LoginDoctorCubit>(),
            child: const SignInDoctor(),
          ),
          settings,
        );

      case PageRouteNames.sign_up_doctor:
        return _createRoute(
              (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => sl<DoctorRegistrationCubit>(),
              ),
              BlocProvider(
                create: (context) => sl<SpecialitiesCubit>(),
              ),
            ],
            child: SignUpDoctor(),
          ),
          settings,
        );

      case PageRouteNames.SelectScreen:
        return _createRoute(
              (context) => const SelectScreen(),
          settings,
        );

      case PageRouteNames.patienthome:
        return _createRoute(
              (context) => BlocProvider(
            create: (context) => sl<AuthCubit>(),
            child: const HomePatient(),
          ),
          settings,
        );

      case PageRouteNames.doctorhome:
        return _createRoute(
              (context) => BlocProvider(
            create: (context) => sl<AuthDoctorCubit>(),
            child: const DoctorHome(),
          ),
          settings,
        );

      default:
        return _createRoute(
              (context) => const UnknownRouteScreen(),
          settings,
        );
    }
  }

  static Route _createRoute(
      Widget Function(BuildContext) builder,
      RouteSettings settings,
      ) {
    return MaterialPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}

class UnknownRouteScreen extends StatelessWidget {
  const UnknownRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'Oops! The page you are looking for does not exist.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                PageRouteNames.initial,
                    (route) => false,
              ),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}