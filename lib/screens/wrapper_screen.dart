import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/data_controller.dart';
import 'package:task_manager/screens/home_screen.dart';
import 'package:task_manager/screens/login_screen.dart';

class Wrapper extends StatelessWidget {
  final Data data = Get.find();
  String? email;
  String? password;
  Wrapper({super.key, this.email, this.password});

  @override
  Widget build(BuildContext context) {
    // Check if the user is loged in or not
    // If loged in then go to HomePage otherwise go to Login Screen
    return GetBuilder<Data>(builder: (_) {
      // email and password send to auto login
      if (data.token == null) return LoginScreen(email: email, password: password);
      // Returnning back will make the email and password null to prevent auto login
      email = null;
      password = null;
      return const HomeScreen();
    });
  }
}
