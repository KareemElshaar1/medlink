import 'dart:math';

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
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // In a real app, this would integrate with an email service
    print('Sending verification code $code to $email for $name');
  }
}
