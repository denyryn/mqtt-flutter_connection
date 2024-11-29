import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_theme.dart';
import 'routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter and MQTT',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      darkTheme: AppTheme.darkTheme,
      getPages: Routes.pages,
      initialRoute: Routes.home,
      defaultTransition: Transition.fade,
    );
  }
}
