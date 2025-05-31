// lib/presentation/screens/signup/sign_up_patient_viewmodel.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../domain/entities/patient_entities.dart';
import '../cubit/patient_register_cubit.dart';
import 'confirm.dart';
import 'email.dart';

class SignUpPatientViewModel {
  final PatientRegistrationCubit _cubit;

  SignUpPatientViewModel(this._cubit);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  DateTime? selectedBirthDate;

  String? verificationCode;

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedBirthDate) {
      selectedBirthDate = picked;
    }
  }

  String _generateCode() {
    final rand = Random();
    return (100000 + rand.nextInt(900000)).toString();
  }

  Future<void> handleSignUp(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      if (selectedBirthDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select your birth date"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        final patient = Patient(
          name: nameController.text,
          birthDate:
              "${selectedBirthDate!.year}-${selectedBirthDate!.month.toString().padLeft(2, '0')}-${selectedBirthDate!.day.toString().padLeft(2, '0')}",
          email: emailController.text,
          phone: phoneController.text,
          password: passwordController.text,
          confirmPassword: confirmPasswordController.text,
        );

        // First register the patient
        await _cubit.registerPatient(patient);

        // Generate and send verification code
        verificationCode = _generateCode();
        try {
          await EmailService.sendVerificationCode(
            name: patient.name,
            email: patient.email,
            code: verificationCode!,
          );

          // Navigate to confirmation screen
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ConfirmCodeScreen(
                  correctCode: verificationCode!,
                  cubit: _cubit,
                ),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Failed to send verification code: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration failed: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
