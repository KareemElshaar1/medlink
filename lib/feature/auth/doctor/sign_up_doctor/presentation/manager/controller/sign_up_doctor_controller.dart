import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../specilaity/domain/entities/speciality_entity.dart';
import '../../../../../../specilaity/manger/cubit/specialities_cubit.dart';
import '../doctor_registration_cubit.dart';
import '../../../../../../../core/services/email_service.dart';
import '../../../../../../../core/routes/page_routes_name.dart';

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

      // Generate verification code
      _verificationCode = EmailService.generateVerificationCode();

      try {
        // Send verification code
        await EmailService.sendVerificationCode(
          name: '${firstNameController.text} ${lastNameController.text}',
          email: emailController.text,
          code: _verificationCode!,
        );

        // Navigate to verification screen
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
              content: Text('Error sending verification code: $e'),
              backgroundColor: Colors.red,
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
