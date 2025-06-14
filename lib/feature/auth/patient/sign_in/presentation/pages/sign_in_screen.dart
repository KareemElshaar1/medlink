// lib/presentation/screens/auth/patient/sign_in/presentation/pages/sign_in_patient.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../../core/extensions/navigation.dart';
import '../../../../../../../core/extensions/padding.dart';
import '../../../../../../../core/routes/page_routes_name.dart';
import '../../../../../../../core/widgets/buildHeader.dart' hide ColorsManager;
import '../../../../../../../core/utils/color_manger.dart';

import '../../../../../../di.dart';
import '../../domain/repositories/auth_repo.dart';
import '../manager/auth_cubit.dart';
import '../manager/cubit/login_cubit.dart';
import '../manager/cubit/login_state.dart';
import '../widgets/login_form.dart';

class SignInPatient extends StatefulWidget {
  const SignInPatient({super.key});

  @override
  State<SignInPatient> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInPatient>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool isObscureText = true;
  bool? isRememberMeSelected = false;
  bool isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Controllers for form fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _loadSavedPreferences();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  Future<void> _loadSavedPreferences() async {
    final authRepository = sl<AuthRepository>();
    final rememberMe = await authRepository.getRememberMePreference();

    if (rememberMe) {
      final email = await authRepository.getEmail();
      if (email != null && email.isNotEmpty && mounted) {
        _emailController.text = email;
      }
    }

    if (mounted) {
      setState(() {
        isRememberMeSelected = rememberMe;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: ColorsManager.background,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: ColorsManager.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: ColorsManager.background,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          setState(() {
            isLoading = true;
          });
        } else {
          setState(() {
            isLoading = false;
          });

          if (state is LoginFailure) {
            _showErrorSnackBar(state.message);
          } else if (state is LoginSuccess) {
            // Navigate to home page
            Navigator.of(context)
                .pushReplacementNamed(PageRouteNames.patienthome);
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  const MedLinkHeader(height: 250, showAnimation: true),

                  // Login Form
                  LoginForm(
                    formKey: _formKey,
                    isObscureText: isObscureText,
                    isRememberMeSelected: isRememberMeSelected,
                    isLoading: isLoading,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    onObscureTextChanged: (value) {
                      setState(() {
                        isObscureText = value;
                      });
                    },
                    onRememberMeChanged: (value) {
                      setState(() {
                        isRememberMeSelected = value;
                      });
                    },
                    onLoginPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();

                        context.read<LoginCubit>().login(
                              email,
                              password,
                              isRememberMeSelected ?? false,
                            );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
