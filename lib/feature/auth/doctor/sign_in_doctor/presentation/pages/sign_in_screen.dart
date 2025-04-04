// lib/presentation/screens/auth/patient/sign_in/presentation/pages/sign_in_patient.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../../core/extensions/navigation.dart';
import '../../../../../../../core/extensions/padding.dart';
import '../../../../../../../core/routes/page_routes_name.dart';
import '../../../../../../../core/widgets/buildHeader.dart';

import '../../../../../../di.dart';
import '../../domain/repositories/auth_repo.dart';
import '../manager/auth_cubit.dart';
import '../manager/cubit/login_cubit.dart';
import '../manager/cubit/login_state.dart';
import '../widgets/login_form.dart';

class SignInDoctor extends StatefulWidget {
  const SignInDoctor({super.key});

  @override
  State<SignInDoctor> createState() => _SignInScreenState();
}

// class _SignInScreenState extends State<SignInPatient>
//     with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   bool isObscureText = true;
//   bool? isRememberMeSelected = false;
//   bool isLoading = false;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//
//   // Controllers for form fields
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _animationController.forward();
//
//     // Load saved preferences
//     _loadSavedPreferences();
//   }
//
//   Future<void> _loadSavedPreferences() async {
//     final authRepository = sl<AuthRepository>();
//     final rememberMe = await authRepository.getRememberMePreference();
//
//     if (rememberMe) {
//       final email = await authRepository.getEmail();
//       if (email != null && email.isNotEmpty) {
//         _emailController.text = email;
//       }
//     }
//
//     setState(() {
//       isRememberMeSelected = rememberMe;
//     });
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Use BlocListener directly without wrapping in BlocProvider
//     return BlocListener<LoginCubit, LoginState>(
//       listener: (context, state) {
//         if (state is LoginLoading) {
//           setState(() {
//             isLoading = true;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//           });
//
//           if (state is LoginFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           } else if (state is LoginSuccess) {
//             // Navigate to home page
//             Navigator.of(context).pushReplacementNamed(PageRouteNames.Home);
//           }
//         }
//       },
//       child: Scaffold(
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: FadeTransition(
//               opacity: _fadeAnimation,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Header
//                   const MedLinkHeader(height: 250, showAnimation: true),
//
//                   // Login Form
//                   LoginForm(
//                     formKey: _formKey,
//                     isObscureText: isObscureText,
//                     isRememberMeSelected: isRememberMeSelected,
//                     isLoading: isLoading,
//                     emailController: _emailController,
//                     passwordController: _passwordController,
//                     onObscureTextChanged: (value) {
//                       setState(() {
//                         isObscureText = value;
//                       });
//                     },
//                     onRememberMeChanged: (value) {
//                       setState(() {
//                         isRememberMeSelected = value;
//                       });
//                     },
//                     onLoginPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         final email = _emailController.text.trim();
//                         final password = _passwordController.text.trim();
//
//                         // Use the BlocProvider from the parent widget
//                         context.read<LoginCubit>().login(
//                           email,
//                           password,
//                           isRememberMeSelected ?? false,
//                         );
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
class _SignInScreenState extends State<SignInDoctor>
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
    final authRepository = sl<AuthRepositoryDoctor>();
    final rememberMe = await authRepository.getRememberMePreference();

    if (rememberMe) {
      final email = await authRepository.getEmail();
      if (email != null && email.isNotEmpty) {
        _emailController.text = email;
      }
    }

    setState(() {
      isRememberMeSelected = rememberMe;
    });
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
    return BlocListener<LoginDoctorCubit, LoginDoctorState>(
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is LoginSuccess) {
            // Navigate to home page
            Navigator.of(context).pushReplacementNamed(PageRouteNames.doctorhome);
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
                  Text("doctor"),

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

                        // Trigger login using the LoginCubit
                        context.read<LoginDoctorCubit>().login(
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