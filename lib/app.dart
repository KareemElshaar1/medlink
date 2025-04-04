import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/routes/page_routes_name.dart';
import 'core/routes/routes.dart';

class Medlink extends StatelessWidget {
  const Medlink({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor:
                Colors.transparent, // Set the AppBar background to transparent
            elevation: 0, // Optionally remove shadow
          ),
        ),
        initialRoute: PageRouteNames.initial,
        onGenerateRoute: Routes.onGeneratedRoute,
      ),
    );
  }
}
