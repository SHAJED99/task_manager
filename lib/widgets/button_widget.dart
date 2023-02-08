import 'package:flutter/material.dart';
import 'package:task_manager/style.dart';

class CustomIconButton extends StatelessWidget {
  final Function()? onTap;
  final Widget? icon;
  final double size;
  final double padding;
  final Color backgroundColor;
  const CustomIconButton({super.key, this.onTap, this.icon, this.size = 16, this.padding = 2, this.backgroundColor = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: backgroundColor,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: size,
            height: size,
            child: AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: FittedBox(child: icon ?? Container()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomElevatedButton extends StatefulWidget {
  const CustomElevatedButton({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding / 2),
    this.onPressed,
    this.height = defaultBoxHeight,
    this.isEnable = true,
    this.enableBackgroundColor,
    this.child,
    this.boxShadow = defaultShadow,
    this.onLoading,
    this.borderRadius = defaultPadding,
    this.width,
  });
  final EdgeInsetsGeometry? padding;
  final double height;
  final double? width;
  final bool isEnable;
  final Color? enableBackgroundColor;
  final Widget? child;
  final Widget? onLoading;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;
  final Function()? onPressed;

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(widget.borderRadius), boxShadow: widget.boxShadow),
      child: Material(
        color: widget.enableBackgroundColor ?? Theme.of(context).primaryColor,
        child: InkWell(
          onTap: !widget.isEnable
              ? null
              : () async {
                  if (isLoading) return;
                  setState(() => isLoading = true);
                  if (widget.onPressed != null) await widget.onPressed!();
                  if (mounted) setState(() => isLoading = false);
                },
          child: Container(
            alignment: Alignment.center,
            padding: widget.padding,
            height: widget.height < 0 ? null : widget.height,
            child: widget.onLoading == null ? widget.child : (isLoading ? widget.onLoading : widget.child),
          ),
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final Widget? child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final TextStyle? textStyle;
  final Color? disabledColor;
  final BorderRadiusGeometry? borderRadius;
  final Function? onPressed;
  final bool isEnable;
  const CustomTextButton({super.key, this.child, this.padding, this.textStyle, this.onPressed, this.borderRadius, this.isEnable = true, this.disabledColor, this.margin, this.backgroundColor});

  TextStyle _textStyle(BuildContext context) {
    if (!isEnable && disabledColor != null && textStyle != null) {
      return textStyle!.copyWith(color: disabledColor);
    }

    return textStyle ?? Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).primaryColor) ?? const TextStyle();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(4),
        child: Material(
          color: backgroundColor ?? Colors.transparent,
          child: InkWell(
            onTap: () {
              if (onPressed == null || !isEnable) return;
              onPressed!();
            },
            child: Container(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: DefaultTextStyle(
                style: _textStyle(context),
                child: child ?? Container(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
