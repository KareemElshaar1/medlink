import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medlink/core/routes/page_routes_name.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../feature/Selection/select_screen.dart';
import '../../feature/auth/doctor/sign_in_doctor/presentation/manager/auth_cubit.dart';
import '../../feature/auth/doctor/sign_in_doctor/presentation/manager/cubit/login_cubit.dart';
import '../../feature/auth/doctor/sign_in_doctor/presentation/pages/sign_in_screen.dart';
import '../../feature/auth/doctor/sign_up_doctor/presentation/manager/doctor_registration_cubit.dart';
import '../../feature/auth/doctor/sign_up_doctor/presentation/pages/sign_up_screen.dart';
import '../../feature/auth/patient/sign_in/presentation/manager/auth_cubit.dart';
import '../../feature/auth/patient/sign_in/presentation/manager/cubit/login_cubit.dart';
import '../../feature/auth/patient/sign_in/presentation/pages/sign_in_screen.dart';
import '../../feature/auth/patient/sign_up/presentation/manager/cubit/patient_register_cubit.dart';
import '../../feature/auth/patient/sign_up/presentation/pages/sign_up_screen.dart';
import '../../feature/checkout/presentation/checkout_screen.dart';
import '../../feature/doctor/clinic/presentation/cubit/clinic_cubit.dart';
import '../../feature/doctor/clinic/presentation/pages/clinic_list_page_fixed.dart';
import '../../feature/doctor/profile/presentation/pages/doctor_profile_page.dart';
import '../../feature/doctor/profile/presentation/cubit/doctor_profile_cubit.dart';
import '../../feature/doctor/profile/edit_profile_page.dart';
import '../../feature/doctor/profile/data/models/doctor_profile_model.dart';
import '../../feature/doctor/schedule/presentation/screens/schedule_list_screen.dart';
import '../../feature/doctor/schedule/presentation/screens/create_schedule_screen.dart';
import '../../feature/doctor/schedule/presentation/screens/edit_schedule_screen.dart';
import '../../feature/doctor/schedule/presentation/cubit/schedule_cubit.dart';
import '../../feature/doctor/schedule/data/models/schedule_model.dart';
import '../../feature/onboarding/ui/on_boarding_screen.dart';
import '../../feature/doctor/doctor_dashboard/doctor_home.dart';
import '../../feature/patient/home_patient.dart';
import '../../feature/patient/payment/presentation/cubit/payment_cubit.dart';
import '../../feature/patient/payment/presentation/pages/payment_page.dart';
import '../../feature/patient/profile/presentation/cubit/patient_profile_cubit.dart';
import '../../feature/patient/profile/presentation/pages/patient_profile_page.dart';
import '../../feature/patient/search/presentation/cubit/search_cubit.dart';
import '../../feature/patient/search/presentation/pages/search_page.dart';
import '../../feature/patient/specilaity/manger/cubit/specialities_cubit.dart';
import '../../feature/splash/toggle_screen.dart';
import '../../feature/auth/doctor/sign_up_doctor/presentation/pages/confirm_doctor_code_screen.dart';
import '../../feature/doctor/appointments/presentation/screens/appointments_screen.dart';
import '../../feature/pharmacy/presentation/product_page.dart';
import '../../feature/pharmacy/presentation/cubit/product_cubit.dart';
import '../../feature/google map/presentation/google_map_page.dart';

class Routes {
  static Route onGeneratedRoute(RouteSettings settings) {
    switch (settings.name) {
      case PageRouteNames.initial:
        return _createRoute(
          (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) =>
                      GetIt.instance<AuthCubit>()..checkAuthStatus()),
              BlocProvider(
                  create: (context) =>
                      GetIt.instance<AuthDoctorCubit>()..checkAuthStatus()),
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
            create: (context) => GetIt.instance<LoginCubit>(),
            child: const SignInPatient(),
          ),
          settings,
        );

      case PageRouteNames.sign_up_patient:
        return _createRoute(
          (context) => BlocProvider(
            create: (context) => GetIt.instance<PatientRegistrationCubit>(),
            child: const SignUpPatient(),
          ),
          settings,
        );

      case PageRouteNames.sign_in_doctor:
        return _createRoute(
          (context) => BlocProvider(
            create: (context) => GetIt.instance<LoginDoctorCubit>(),
            child: const SignInDoctor(),
          ),
          settings,
        );

      case PageRouteNames.sign_up_doctor:
        return _createRoute(
          (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) =>
                      GetIt.instance<DoctorRegistrationCubit>()),
              BlocProvider(
                  create: (context) => GetIt.instance<SpecialitiesCubit>()),
            ],
            child: const SignUpDoctor(),
          ),
          settings,
        );

      case PageRouteNames.confirm_doctor_code:
        final args = settings.arguments as Map<String, dynamic>;
        return _createRoute(
          (context) => ConfirmDoctorCodeScreen(
            correctCode: args['code'] as String,
            cubit: args['cubit'] as DoctorRegistrationCubit,
            registrationData: args['registrationData'] as Map<String, dynamic>,
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
            create: (context) => GetIt.instance<AuthCubit>(),
            child: const HomePatient(),
          ),
          settings,
        );

      case PageRouteNames.doctorhome:
        return _createRoute(
          (context) => BlocProvider(
            create: (context) => GetIt.instance<AuthDoctorCubit>(),
            child: const DoctorHome(),
          ),
          settings,
        );

      case PageRouteNames.clinicList:
        return _createRoute(
          (context) => BlocProvider(
            create: (context) => GetIt.instance<ClinicCubit>(),
            child: const ClinicListPage(),
          ),
          settings,
        );

      case PageRouteNames.doctorProfile:
        return _createRoute(
          (context) => BlocProvider(
            create: (context) => GetIt.instance<DoctorProfileCubit>(),
            child: const DoctorProfilePage(),
          ),
          settings,
        );

      case PageRouteNames.editProfile:
        final profile = settings.arguments as DoctorProfileModel;
        return _createRoute(
          (context) => EditProfilePage(initialProfile: profile),
          settings,
        );

      case PageRouteNames.scheduleList:
        return _createRoute(
          (context) => const ScheduleListScreen(),
          settings,
        );

      case PageRouteNames.createSchedule:
        return _createRoute(
          (context) => BlocProvider(
            create: (context) => GetIt.instance<ScheduleCubit>()..getClinics(),
            child: const CreateScheduleScreen(),
          ),
          settings,
        );

      case PageRouteNames.editSchedule:
        final schedule = settings.arguments as ScheduleModel;
        return _createRoute(
          (context) => BlocProvider(
            create: (context) => GetIt.instance<ScheduleCubit>()..getClinics(),
            child: EditScheduleScreen(schedule: schedule),
          ),
          settings,
        );

      case PageRouteNames.search:
        return _createRoute(
          (context) => BlocProvider(
            create: (context) => GetIt.instance<SearchCubit>(),
            child: const SearchPage(),
          ),
          settings,
        );

      case PageRouteNames.payment:
        return _createRoute(
          (context) => Provider<PaymentCubit>(
            create: (context) => GetIt.instance<PaymentCubit>(),
            child: const PaymentPage(),
          ),
          settings,
        );

      case PageRouteNames.patientProfile:
        return _createRoute(
          (context) => BlocProvider(
            create: (context) => GetIt.instance<AuthCubit>(),
            child: BlocProvider(
              create: (context) => GetIt.instance<PatientProfileCubit>(),
              child: const PatientProfilePage(),
            ),
          ),
          settings,
        );

      case PageRouteNames.appointments:
        return _createRoute(
          (context) => const AppointmentsScreen(),
          settings,
        );

      case PageRouteNames.pharmacy:
        return _createRoute(
          (context) => BlocProvider(
            create: (context) => GetIt.instance<ProductCubit>(),
            child: Builder(
              builder: (context) => const ProductPage(),
            ),
          ),
          settings,
        );

      case PageRouteNames.checkout:
        return _createRoute(
          (context) => const CheckoutScreen(),
          settings,
        );

      case PageRouteNames.map:
        return _createRoute(
          (context) => const MapScreen(),
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
