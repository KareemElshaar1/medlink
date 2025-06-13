import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this package

import 'app.dart';
import 'core/helper/constants.dart';
import 'core/helper/shared_pref_helper.dart';
import 'di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait mode
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await SharedPrefHelper.init();
  // await checkIfLoggedInUser();
  await init(); // Initialize dependency injection

  runApp(const Medlink());
}

// Future<void> checkIfLoggedInUser() async {
//   String? userToken =
//       await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);

//   isLoggedInUser = userToken?.isNotEmpty ?? false;
// }
