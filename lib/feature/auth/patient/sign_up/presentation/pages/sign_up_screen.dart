import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:medlink/core/extensions/padding.dart';

import '../../../../../../core/widgets/buildHeader.dart';
 import '../manager/controller/sign_up_patient_controller.dart';
import '../manager/cubit/patient_register_cubit.dart';
import '../widgets/sign_up_form_patient.dart';

class SignUpPatient extends StatefulWidget {
  const SignUpPatient({super.key});

  @override
  State<SignUpPatient> createState() => _SignUpPatientState();
}

class _SignUpPatientState extends State<SignUpPatient> {
  late final SignUpPatientViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel =
        SignUpPatientViewModel(context.read<PatientRegistrationCubit>());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Animated Header
              const MedLinkHeader(height: 220, showAnimation: true),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Gap(30),
                    // Title
                    _buildSignUpTitle(),
                    const Gap(30),

                    // Form
                    SignUpForm(viewModel: _viewModel),
                    const Gap(30),

                    // Social Sign Up Section
                    //  const SignUpAlternatives(),
                    const Gap(40),
                  ],
                ).setHorizontalPadding(context, enableScreenUtil: true, 24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpTitle() {
    return Column(
      children: [
        Text(
          "Sign Up as Patient",
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            "Create your account to access healthcare services",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
