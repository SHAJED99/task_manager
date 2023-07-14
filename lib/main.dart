// CRUD is a dummy app that can create, read, update and delete data using Rest API
// Task manager

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/screens/splash_screen.dart';
import 'package:task_manager/style.dart';

void main(List<String> args) => runApp(
      GetMaterialApp(
        scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse
        }),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: primarySwatch),
        home: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
