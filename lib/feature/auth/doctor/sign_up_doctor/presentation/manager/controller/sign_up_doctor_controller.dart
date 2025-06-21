import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../../../patient/specilaity/domain/entities/speciality_entity.dart';
import '../../../../../../patient/specilaity/manger/cubit/specialities_cubit.dart';
import '../../../../../patient/sign_up/presentation/manager/controller/email.dart';
import '../doctor_registration_cubit.dart';
import '../../../../../../../core/routes/page_routes_name.dart';
import '../../../../../../../core/services/email_service.dart';
import '../../../../../patient/sign_up/presentation/manager/controller/email.dart';



class SignUpDoctorController {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? phoneNumber;
  Speciality? selectedSpeciality;
  BuildContext? _context;
  String? _verificationCode;

  // Store registration data for later use
  Map<String, dynamic>? _registrationData;

  void init(BuildContext context) {
    _context = context;
    context.read<SpecialitiesCubit>().getSpecialities();
  }

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  Future<void> handleSignUp() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState!.save();

      // Store registration data
      _registrationData = {
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'phone': phoneNumber ?? "",
        'password': passwordController.text,
        'confirmPassword': confirmPasswordController.text,
        'specialityId': selectedSpeciality?.id ?? 0,
      };

      try {
        // First register the doctor
        await _context!.read<DoctorRegistrationCubit>().registerDoctor(
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              email: emailController.text,
              phone: phoneNumber ?? "",
              password: passwordController.text,
              confirmPassword: confirmPasswordController.text,
              specialityId: selectedSpeciality?.id ?? 0,
            );

        // Only proceed with verification if registration was successful
        if (_context!.read<DoctorRegistrationCubit>().state
            is DoctorRegistrationSuccess) {
          // Generate verification code
          _verificationCode = EmailService.generateVerificationCode();

          try {
            // Send verification code
            debugPrint(
                'Attempting to send verification code to ${emailController.text}');
            await EmailService.sendVerificationCode(
              name: '${firstNameController.text} ${lastNameController.text}',
              email: emailController.text,
              code: _verificationCode!,
            );

            // Navigate to verification screen only after successful registration and email sending
            if (_context != null) {
              Navigator.of(_context!).pushNamed(
                PageRouteNames.confirm_doctor_code,
                arguments: {
                  'code': _verificationCode,
                  'cubit': _context!.read<DoctorRegistrationCubit>(),
                  'registrationData': _registrationData,
                },
              );
            }
          } catch (e) {
            if (_context != null) {
              ScaffoldMessenger.of(_context!).showSnackBar(
                SnackBar(
                  content:
                      Text('Failed to send verification code: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }
      } catch (e) {
        if (_context != null) {
          String errorMessage = 'Registration failed';
          if (e is DioException) {
            if (e.response?.data is Map<String, dynamic>) {
              final errorData = e.response?.data as Map<String, dynamic>;
              if (errorData.containsKey('detail')) {
                errorMessage = errorData['detail'].toString();
              }
            }
          }
          ScaffoldMessenger.of(_context!).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(_context!).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      }
    }
  }

  void onSpecialityChanged(Speciality? newValue) {
    selectedSpeciality = newValue;
  }

  void onPhoneChanged(String phone) {
    phoneNumber = phone;
  }
}
