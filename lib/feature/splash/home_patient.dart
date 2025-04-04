import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/routes/page_routes_name.dart';
import '../auth/patient/sign_in/presentation/manager/auth_cubit.dart';
import '../auth/patient/sign_in/presentation/manager/auth_state.dart';


class HomePatient extends StatelessWidget {
  const HomePatient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MedLink Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.of(
              context,
            ).pushReplacementNamed(PageRouteNames.sign_in_patient);
          }
        },
        child: const Center(child: Text('Welcome to MedLink!')),
      ),
    );
  }
}
