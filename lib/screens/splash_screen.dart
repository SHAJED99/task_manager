import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:get/get.dart';
import 'package:task_manager/constant_variable.dart';
import 'package:task_manager/controllers/data_controller.dart';
import 'package:task_manager/screens/wrapper_screen.dart';
import 'package:task_manager/style.dart';
import 'package:task_manager/widgets/background_image_widget.dart';

class SplashScreen extends StatefulWidget {
  final String? message;
  const SplashScreen({super.key, this.message});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Data data = Get.put(Data());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => endSplash());
  }

  // Change screen after showing splash
  endSplash() async {
    Future.delayed(splashScreenDuration).then((value) => Get.off(() => Wrapper()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundImage(
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Showing Company Logo
              const Center(
                child: Image(
                  image: Svg("./lib/assets/icons/logo.svg"),
                  width: 100,
                ),
              ),
              // Showing if there is an error
              if (widget.message != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: defaultPadding,
                  child: Center(
                    child: Text(
                      widget.message ?? "",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: subTitle1,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
