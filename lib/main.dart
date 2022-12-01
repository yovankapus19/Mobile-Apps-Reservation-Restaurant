import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/users/authentication/login_screen.dart';
import 'package:flutter_ecommerce/users/fragments/dashboard_of_fragments.dart';
import 'package:flutter_ecommerce/users/userPrefrences/user_prefrences.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // For Using Get we mush using GetMaterialApp
    return GetMaterialApp(
      title: 'Foodies Apps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Color(0xFFF5F5f3)),
      home: FutureBuilder(
          future: RememberUserPrefs.readUserInfo(),
          builder: (context, dataSnapShot) {
            if (dataSnapShot.data == null) {
              return const LoginScreen();
            } else {
              return DashboardOfFragments();
            }
          }),
    );
  }
}
