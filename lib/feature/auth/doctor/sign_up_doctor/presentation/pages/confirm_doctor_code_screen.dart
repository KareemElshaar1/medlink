import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../../../core/routes/page_routes_name.dart';
import '../manager/doctor_registration_cubit.dart';

class ConfirmCodeScreen extends StatefulWidget {
  final String correctCode;
  final  DoctorRegistrationCubit cubit;

  const ConfirmCodeScreen({
    super.key,
    required this.correctCode,
    required this.cubit,
  });

  @override
  State<ConfirmCodeScreen> createState() => _ConfirmCodeScreenState();
}

class _ConfirmCodeScreenState extends State<ConfirmCodeScreen> {
  final TextEditingController codeController = TextEditingController();
  bool _isVerifying = false;

  Future<void> _verifyCode() async {
    if (codeController.text == widget.correctCode) {
      setState(() {
        _isVerifying = true;
      });

      try {
        // Send token after successful verification
        await widget.cubit.sendVerificationToken();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Code Verified Successfully! Please sign in.'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to the sign in screen
          Navigator.of(context).pushNamedAndRemoveUntil(
            PageRouteNames.sign_in_doctor,
            (route) => false, // Remove all previous routes
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error sending token: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isVerifying = false;
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Incorrect Code!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter the verification code sent to your email",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: "Verification Code",
                border: OutlineInputBorder(),
                counterText: "",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isVerifying ? null : _verifyCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isVerifying
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Verify",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
// lib/core/services/email_service.dart


class EmailService {
  static const String serviceId = 'service_yrju1ai';
  static const String templateId = 'template_gevr1nq';
  static const String userId = 'Yz-iMDP9ZtqIodMJ1';

  static String generateVerificationCode() {
    // Generate a 6-digit code
    final random = Random();
    final code = List.generate(6, (_) => random.nextInt(10)).join();
    return code;
  }

  static Future<void> sendVerificationCode({
    required String name,
    required String email,
    required String code,
  }) async {
    try {
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'origin': 'http://localhost',
        },
        body: jsonEncode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'to_email': email,
            'user_name': name,
            'user_email': email,
            'verification_code': code,
          },
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send verification code: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error sending verification code: $e');
      rethrow;
    }
  }
}
