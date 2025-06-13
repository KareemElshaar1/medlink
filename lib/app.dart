import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/routes/page_routes_name.dart';
import 'core/routes/routes.dart';
 
class Medlink extends StatelessWidget {
  const Medlink({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
       // home: const ProductPage(),
        initialRoute: PageRouteNames.initial,
        onGenerateRoute: Routes.onGeneratedRoute,
      ),
    );
  }
}
