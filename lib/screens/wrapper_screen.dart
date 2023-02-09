import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/data_controller.dart';
import 'package:task_manager/screens/home_screen.dart';
import 'package:task_manager/screens/login_screen.dart';

class Wrapper extends StatefulWidget {
  final String? email;
  final String? password;
  const Wrapper({super.key, this.email, this.password});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final Data data = Get.find();

  String? email;
  String? password;

  @override
  void initState() {
    super.initState();
    email = widget.email;
    password = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    // Check if the user is loged in or not
    // If loged in then go to HomePage otherwise go to Login Screen
    return GetBuilder<Data>(builder: (_) {
      // email and password send to auto login
      if (data.token == null) return LoginScreen(email: widget.email, password: widget.password);
      // Returnning back will make the email and password null to prevent auto login
      email = null;
      password = null;
      return const HomeScreen();
    });
  }
}
