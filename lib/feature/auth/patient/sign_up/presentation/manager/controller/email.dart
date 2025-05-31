// lib/core/services/email_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:flutter/material.dart';

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
