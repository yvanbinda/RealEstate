import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realestate_app/Authentication/login/login.dart';
import 'package:realestate_app/theme/dark_theme.dart';
import 'package:realestate_app/theme/light_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'Controllers/auth_controller.dart';
import 'Controllers/controller.dart';
import 'Pages/Home/home.dart';
import 'Pages/HomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Controller.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightMode,
          darkTheme: darkMode,
          home: AuthWrapper(), // Use AuthWrapper to handle initial routing
        );
      },
    );
  }
}

// AuthWrapper to check login status and redirect accordingly
class AuthWrapper extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_authController.isLoading.value) {
        // Show a loading indicator while checking auth state
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (_authController.user != null) {
        // User is logged in, redirect to HomePage
        return HomePage();
      } else {
        // User is not logged in, redirect to Login
        return Login();
      }
    });
  }
}