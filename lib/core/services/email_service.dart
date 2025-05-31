import 'dart:math';
import 'dart:async';

class EmailService {
  static String generateVerificationCode() {
    final random = Random();
    return List.generate(6, (_) => random.nextInt(10)).join();
  }

  static Future<void> sendVerificationCode({
    required String name,
    required String email,
    required String code,
  }) async {
    await Future.delayed(const Duration(seconds: 5));
  }
}
