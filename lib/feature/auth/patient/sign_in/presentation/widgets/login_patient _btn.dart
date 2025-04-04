// // 1. First, let's update the LoginButton widget to ensure it's working correctly
// // lib/core/widgets/login_btn.dart (or wherever your LoginButton is defined)
//
// class LoginButton extends StatelessWidget {
//   final bool isLoading;
//   final VoidCallback onPressed;
//
//   const LoginButton({
//     Key? key,
//     required this.isLoading,
//     required this.onPressed,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: isLoading ? null : onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.blue, // Your app's primary color
//         minimumSize: Size(double.infinity, 50.h),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//       child: isLoading
//           ? const CircularProgressIndicator(color: Colors.white)
//           : const Text(
//         'Login',
//         style: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }
//
// // 2. Next, update the onLoginPressed function in SignInPatient to directly navigate to HomeScreen
// // In SignInPatient's onLoginPressed function:
//
// onLoginressed;: () {
// if (_formKey.currentState!.validate()) {
// final email = _emailController.text.trim();
// final password = _passwordController.text.trim();
//
// // First attempt with BlocProvider
// context.read<LoginCubit>().login(
// email,
// password,
// isRememberMeSelected ?? false,
// );
// }
// }
//
// // 3. Update the BlocListener in SignInPatient to ensure proper navigation after login success:
// BlocListener<LoginCubit, LoginState>(
// listener: (context, state) {
// if (state is LoginLoading) {
// setState(() {
// isLoading = true;
// });
// } else {
// setState(() {
// isLoading = false;
// });
//
// if (state is LoginFailure) {
// ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(content: Text(state.message)),
// );
// } else if (state is LoginSuccess) {
// // Direct navigation to HomeScreen
// Navigator.of(context).pushAndRemoveUntil(
// MaterialPageRoute(builder: (context) => const HomeScreen()),
// (route) => false, // Removes all previous routes
// );
//
// // Also update the AuthCubit state
// if (context.read<AuthCubit>() != null) {
// context.read<AuthCubit>().checkAuthStatus();
// }
// }
// }
// },
// child: // Rest of your UI
// )
//
// // 4. Make sure HomeScreen is correctly imported wherever you're using it:
// import 'package:flutter/material.dart';
//
// import 'path_to_your_home_screen/home_screen.dart';