import 'package:flutter/material.dart';

import '../../../domain/entities/patient_entities.dart';
import '../cubit/patient_register_cubit.dart';

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

  void handleSignUp(BuildContext context) {
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

      final patient = Patient(
        name: nameController.text,
        birthDate:
            "${selectedBirthDate!.year}-${selectedBirthDate!.month.toString().padLeft(2, '0')}-${selectedBirthDate!.day.toString().padLeft(2, '0')}",
        email: emailController.text,
        phone: phoneController.text,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      );

      _cubit.registerPatient(patient);
    }
  }
}
