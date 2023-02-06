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
  const CustomCard({super.key, this.child, this.onTap, this.height, this.alignment = Alignment.center, this.boxShadow = defaultShadow, this.clipBehavior = Clip.antiAlias, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: clipBehavior,
      margin: const EdgeInsets.all(defaultPadding / 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(defaultPadding / 4),
        boxShadow: boxShadow,
      ),
      child: Material(
        color: backgroundColor ?? Theme.of(context).cardColor,
        child: InkWell(
          onTap: onTap,
          child: Container(
            alignment: height == null ? null : alignment,
            height: height,
            child: child ?? Container(),
          ),
        ),
      ),
    );
  }
}
