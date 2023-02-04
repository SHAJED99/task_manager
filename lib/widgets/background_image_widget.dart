// This show an image in background

import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class BackgroundImage extends StatelessWidget {
  final Widget? child;

  const BackgroundImage({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: Svg(
            './lib/assets/images/background.svg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
