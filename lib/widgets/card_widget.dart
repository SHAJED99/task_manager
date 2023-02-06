import 'package:flutter/material.dart';
import 'package:task_manager/style.dart';

class CustomCard extends StatelessWidget {
  final Widget? child;
  final double? height;
  final AlignmentGeometry? alignment;
  final List<BoxShadow>? boxShadow;
  final Function()? onTap;
  final Clip clipBehavior;
  final Color? backgroundColor;
  final BoxConstraints? constraints;
  const CustomCard(
      {super.key, this.child, this.onTap, this.height, this.alignment = Alignment.center, this.boxShadow = defaultShadow, this.clipBehavior = Clip.antiAlias, this.backgroundColor, this.constraints});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: clipBehavior,
      margin: const EdgeInsets.all(defaultPadding / 4),
      constraints: constraints,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(defaultPadding / 4),
        boxShadow: boxShadow,
      ),
      child: Material(
        color: backgroundColor ?? Theme.of(context).cardColor,
        child: InkWell(
          onTap: onTap,
          child: Container(
            alignment: alignment,
            height: height,
            child: child ?? Container(),
          ),
        ),
      ),
    );
  }
}
