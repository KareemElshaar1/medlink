import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:medlink/core/utils/color_manger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medlink/core/widgets/custom_text_field.dart';
import 'package:medlink/core/widgets/app_text_button.dart';

// API Service Class
class PasswordResetService {
  static const String baseUrl = 'http://medlink.runasp.net/Auth/User';

  // Step 1: Request reset code
  static Future<Map<String, dynamic>> requestResetCode(String email) async {
    developer.log('Requesting reset code for email: $email',
        name: 'PasswordReset');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/request-reset'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      developer.log('Reset code response status: ${response.statusCode}',
          name: 'PasswordReset');
      developer.log('Reset code response body: ${response.body}',
          name: 'PasswordReset');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Reset code sent successfully',
          'data': jsonDecode(response.body),
        };
      } else {
        String errorMessage = _getErrorMessage(response);
        developer.log('Reset code error: $errorMessage',
            name: 'PasswordReset', error: response.body);
        return {
          'success': false,
          'message': errorMessage,
          'statusCode': response.statusCode,
          'error': response.body,
        };
      }
    } catch (e) {
      developer.log('Reset code exception: $e',
          name: 'PasswordReset', error: e);
      return {
        'success': false,
        'message': _getNetworkErrorMessage(e),
        'error': e.toString(),
      };
    }
  }

  // Step 2: Reset password with code
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String token,
    required String password,
  }) async {
    developer.log('Resetting password for email: $email',
        name: 'PasswordReset');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'token': token,
          'Password': password,
        }),
      );

      developer.log('Reset password response status: ${response.statusCode}',
          name: 'PasswordReset');
      developer.log('Reset password response body: ${response.body}',
          name: 'PasswordReset');

      if (response.statusCode == 200) {
        // For success case, return the plain text message directly
        return {
          'success': true,
          'message': response.body.trim(),
          'data': {'message': response.body.trim()},
        };
      } else {
        String errorMessage = _getErrorMessage(response);
        developer.log('Reset password error: $errorMessage',
            name: 'PasswordReset', error: response.body);
        return {
          'success': false,
          'message': errorMessage,
          'error': response.body,
        };
      }
    } catch (e) {
      developer.log('Reset password exception: $e',
          name: 'PasswordReset', error: e);
      return {
        'success': false,
        'message': _getNetworkErrorMessage(e),
        'error': e.toString(),
      };
    }
  }

  static String _getErrorMessage(http.Response response) {
    String errorMessage;
    switch (response.statusCode) {
      case 400:
        // For 400 status, check the response body for specific error messages
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? 'Invalid request';
        } catch (e) {
          // If not JSON, use the response body directly
          errorMessage = response.body.trim();
          // Map common error messages to user-friendly text
          if (errorMessage.toLowerCase().contains('token')) {
            errorMessage =
                'Invalid or expired reset code. Please request a new code.';
          } else if (errorMessage.toLowerCase().contains('email')) {
            errorMessage = 'Invalid email address';
          } else if (errorMessage.toLowerCase().contains('password')) {
            errorMessage = 'Invalid password format';
          }
        }
        break;
      case 404:
        errorMessage = 'Email not found in our system';
        break;
      case 429:
        errorMessage = 'Too many requests. Please try again later';
        break;
      case 500:
        errorMessage = 'Server error. Please try again later';
        break;
      default:
        // Try to parse as JSON first, if fails use the plain text
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? 'Failed to process request';
        } catch (e) {
          // If not JSON, use the response body directly
          errorMessage = response.body.trim().isNotEmpty
              ? response.body.trim()
              : 'Failed to process request (${response.statusCode})';
        }
    }
    developer.log('Error message generated: $errorMessage',
        name: 'PasswordReset');
    return errorMessage;
  }

  static String _getNetworkErrorMessage(dynamic error) {
    String errorMessage;
    if (error.toString().contains('SocketException')) {
      errorMessage = 'No internet connection';
    } else if (error.toString().contains('TimeoutException')) {
      errorMessage = 'Request timeout. Please try again';
    } else if (error.toString().contains('FormatException')) {
      errorMessage = 'Invalid server response';
    } else {
      errorMessage = 'Network error occurred';
    }
    developer.log('Network error message generated: $errorMessage',
        name: 'PasswordReset');
    return errorMessage;
  }
}

// Password Reset Screen
class PasswordResetScreen extends StatefulWidget {
  final VoidCallback? onPasswordResetSuccess;
  final bool isDoctor;

  const PasswordResetScreen({
    Key? key,
    this.onPasswordResetSuccess,
    this.isDoctor = false,
  }) : super(key: key);

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isCodeSent = false;
  final bool _obscurePassword = true;
  final bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    developer.log('PasswordResetScreen initialized', name: 'PasswordReset');
  }

  @override
  void dispose() {
    developer.log('PasswordResetScreen disposed', name: 'PasswordReset');
    _emailController.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _requestResetCode() async {
    developer.log('Requesting reset code...', name: 'PasswordReset');
    if (!_formKey.currentState!.validate()) {
      developer.log('Form validation failed', name: 'PasswordReset');
      return;
    }

    setState(() => _isLoading = true);
    developer.log('Loading state set to true', name: 'PasswordReset');

    final result = await PasswordResetService.requestResetCode(
      _emailController.text.trim(),
    );

    setState(() => _isLoading = false);
    developer.log('Loading state set to false', name: 'PasswordReset');

    if (result['success']) {
      setState(() => _isCodeSent = true);
      developer.log('Reset code sent successfully', name: 'PasswordReset');
      _showSuccessSnackBar('Reset code sent to your email');
    } else {
      developer.log('Failed to send reset code: ${result['message']}',
          name: 'PasswordReset');
      _showErrorDialog(
        title: 'Failed to Send Reset Code',
        message: result['message'],
        showRetryButton: true,
      );
    }
  }

  Future<void> _resetPassword() async {
    developer.log('Resetting password...', name: 'PasswordReset');
    if (!_formKey.currentState!.validate()) {
      developer.log('Form validation failed', name: 'PasswordReset');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      developer.log('Passwords do not match', name: 'PasswordReset');
      _showErrorSnackBar('Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);
    developer.log('Loading state set to true', name: 'PasswordReset');

    final result = await PasswordResetService.resetPassword(
      email: _emailController.text.trim(),
      token: _tokenController.text.trim(),
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);
    developer.log('Loading state set to false', name: 'PasswordReset');

    if (result['success']) {
      developer.log('Password reset successful', name: 'PasswordReset');
      _showSuccessSnackBar('Password reset successfully');
      widget.onPasswordResetSuccess?.call();
      Navigator.of(context).pop();
    } else {
      developer.log('Password reset failed: ${result['message']}',
          name: 'PasswordReset');
      _showErrorSnackBar(result['message']);
    }
  }

  void _showSuccessSnackBar(String message) {
    developer.log('Showing success snackbar: $message', name: 'PasswordReset');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    developer.log('Showing error snackbar: $message', name: 'PasswordReset');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showErrorDialog({
    required String title,
    required String message,
    bool showRetryButton = false,
  }) {
    developer.log('Showing error dialog: $title - $message',
        name: 'PasswordReset');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 8),
              Text(title),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              const SizedBox(height: 16),
              const Text(
                'Common solutions:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('• Check your internet connection'),
              const Text('• Verify the email address is correct'),
              const Text('• Try again in a few minutes'),
              const Text('• Contact support if problem persists'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
            if (showRetryButton)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _requestResetCode();
                },
                child: const Text('RETRY'),
              ),
          ],
        );
      },
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      developer.log('Password validation failed: empty password',
          name: 'PasswordReset');
      return 'Please enter your password';
    }
    if (value.length < 8) {
      developer.log('Password validation failed: too short',
          name: 'PasswordReset');
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      developer.log('Password validation failed: no uppercase',
          name: 'PasswordReset');
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      developer.log('Password validation failed: no lowercase',
          name: 'PasswordReset');
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      developer.log('Password validation failed: no number',
          name: 'PasswordReset');
      return 'Password must contain at least one number';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      developer.log('Password validation failed: no special character',
          name: 'PasswordReset');
      return 'Password must contain at least one special character';
    }
    developer.log('Password validation passed', name: 'PasswordReset');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.background,
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: TextStyle(
            color: ColorsManager.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        backgroundColor: ColorsManager.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorsManager.primary),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: ColorsManager.primaryWithOpacity(0.1),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.lock_reset,
                          size: 50.w,
                          color: ColorsManager.primary,
                        )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .scale(delay: 200.ms),
                        SizedBox(height: 16.h),
                        Text(
                          'Reset Your Password',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorsManager.textDark,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 400.ms)
                            .slideY(begin: 0.3, end: 0),
                        SizedBox(height: 8.h),
                        Text(
                          'Enter your email to receive a reset code',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorsManager.textLight,
                            fontSize: 14.sp,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 600.ms)
                            .slideY(begin: 0.3, end: 0),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Email Field
                  AppTextFormField(
                    controller: _emailController,
                    hintText: 'Enter your email address',
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(
                      Icons.email,
                      color: ColorsManager.primary,
                      size: 20.w,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 800.ms).slideX(begin: -0.2, end: 0),

                  if (_isCodeSent) ...[
                    SizedBox(height: 16.h),
                    // Reset Code Field
                    AppTextFormField(
                      controller: _tokenController,
                      hintText: 'Enter the code sent to your email',
                      labelText: 'Reset Code',
                      keyboardType: TextInputType.number,
                      prefixIcon: Icon(
                        Icons.security,
                        color: ColorsManager.primary,
                        size: 20.w,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the reset code';
                        }
                        return null;
                      },
                    )
                        .animate()
                        .fadeIn(delay: 1000.ms)
                        .slideX(begin: -0.2, end: 0),

                    SizedBox(height: 16.h),
                    // New Password Field
                    AppTextFormField(
                      controller: _passwordController,
                      hintText: 'Enter your new password',
                      labelText: 'New Password',
                      isObscureText: true,
                      prefixIcon: Icon(
                        Icons.lock,
                        color: ColorsManager.primary,
                        size: 20.w,
                      ),
                      validator: _validatePassword,
                    )
                        .animate()
                        .fadeIn(delay: 1200.ms)
                        .slideX(begin: -0.2, end: 0),

                    SizedBox(height: 16.h),
                    // Confirm Password Field
                    AppTextFormField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirm your new password',
                      labelText: 'Confirm Password',
                      isObscureText: true,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: ColorsManager.primary,
                        size: 20.w,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    )
                        .animate()
                        .fadeIn(delay: 1400.ms)
                        .slideX(begin: -0.2, end: 0),
                  ],

                  SizedBox(height: 24.h),
                  // Submit Button
                  AppTextButton(
                    buttonText:
                        _isCodeSent ? 'Reset Password' : 'Send Reset Code',
                    onPressed: _isLoading
                        ? null
                        : (_isCodeSent ? _resetPassword : _requestResetCode),
                    isLoading: _isLoading,
                    buttonHeight: 50.h,
                    useGradient: true,
                    gradientColors: const [
                      ColorsManager.primaryLight,
                      ColorsManager.primary,
                      ColorsManager.primaryDark,
                    ],
                  ).animate().fadeIn(delay: 1600.ms).scale(delay: 1800.ms),

                  if (_isCodeSent) ...[
                    SizedBox(height: 16.h),
                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isCodeSent = false;
                              _tokenController.clear();
                              _passwordController.clear();
                              _confirmPasswordController.clear();
                            });
                          },
                          child: Text(
                            'Change Email',
                            style: TextStyle(
                              color: ColorsManager.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _isLoading ? null : _requestResetCode,
                          child: Text(
                            'Resend Code',
                            style: TextStyle(
                              color: ColorsManager.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(delay: 1800.ms)
                        .slideY(begin: 0.2, end: 0),

                    SizedBox(height: 20.h),
                    // Help Box
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: ColorsManager.infoWithOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: ColorsManager.infoWithOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: ColorsManager.info,
                                size: 20.w,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Didn\'t receive the code?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorsManager.info,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            '• Check your spam/junk folder\n'
                            '• Make sure the email address is correct\n'
                            '• Wait a few minutes for delivery\n'
                            '• Try resending the code',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: ColorsManager.textMedium,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 2000.ms)
                        .slideY(begin: 0.2, end: 0),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Method 1: Simple Navigation (from any screen)
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
            color: ColorsManager.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        backgroundColor: ColorsManager.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorsManager.primary),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            AppTextFormField(
              hintText: 'Enter your email',
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(
                Icons.email,
                color: ColorsManager.primary,
                size: 20.w,
              ),
            ),
            SizedBox(height: 16.h),
            AppTextFormField(
              hintText: 'Enter your password',
              labelText: 'Password',
              isObscureText: true,
              prefixIcon: Icon(
                Icons.lock,
                color: ColorsManager.primary,
                size: 20.w,
              ),
            ),
            SizedBox(height: 20.h),
            AppTextButton(
              buttonText: 'Login',
              onPressed: () {
                // Login logic
              },
              buttonHeight: 50.h,
              useGradient: true,
              gradientColors: const [
                ColorsManager.primaryLight,
                ColorsManager.primary,
                ColorsManager.primaryDark,
              ],
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PasswordResetScreen(),
                  ),
                );
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: ColorsManager.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
