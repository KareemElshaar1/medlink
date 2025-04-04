import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../core/routes/page_routes_name.dart';
import '../auth/doctor/sign_in_doctor/presentation/manager/auth_cubit.dart';
import '../auth/doctor/sign_in_doctor/presentation/manager/auth_state.dart';
import '../auth/patient/sign_in/presentation/manager/auth_state.dart';


class DoctorHome extends StatelessWidget {
  const DoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DOCTOR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthDoctorCubit>().logout();
            },
          ),
        ],
      ),
      body: BlocListener<AuthDoctorCubit, AuthDoctorState>(
        listener: (context, state) {
          if (state is AuthDoctorUnauthenticated) {
            Navigator.of(
              context,
            ).pushReplacementNamed(PageRouteNames.sign_in_doctor);
          }
        },
        child: const Center(child: Text('Welcome to MedLink!')),
      ),
    );
  }
}
