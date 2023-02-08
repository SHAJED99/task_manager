import 'package:flutter/material.dart';
import 'package:task_manager/style.dart';
import 'package:task_manager/widgets/card_widget.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final double selectedSize;
  final double unselectedSize;
  final Function(int index)? onPressed;
  final double? heigth;
  final Color? selectedForegroundColor;
  final Color? selectedBackgroundColor;
  final Color? unselectedForegroundColor;
  final Color? backgroundColor;
  final List<CustomBottomNavigationBarItems> customBottomNavigationBarItems;
  const CustomBottomNavigationBar({
    Key? key,
    required this.customBottomNavigationBarItems,
    this.selectedIndex = 0,
    this.backgroundColor,
    this.selectedForegroundColor,
    this.heigth = defaultNavHeight,
    this.selectedBackgroundColor,
    this.unselectedForegroundColor,
    this.onPressed,
    this.selectedSize = 16,
    this.unselectedSize = 12,
  }) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late int selectedIndex;

  @override
  void initState() {
    selectedIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      height: widget.heigth,
      child: Row(
        children: [
          for (int index = 0; index < widget.customBottomNavigationBarItems.length; index++)
            Expanded(
              child: Material(
                color: index == selectedIndex ? widget.selectedBackgroundColor ?? Theme.of(context).primaryColor : Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() => selectedIndex = index);
                    if (widget.onPressed != null) widget.onPressed!(index);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Theme(
                      data: ThemeData(
                        iconTheme: IconThemeData(
                          size: index == selectedIndex ? widget.selectedSize + 5 : widget.unselectedSize + 5,
                          color: index == selectedIndex ? widget.selectedForegroundColor ?? Theme.of(context).cardColor : widget.unselectedForegroundColor ?? Theme.of(context).disabledColor,
                        ),
                        textTheme: TextTheme(
                          bodyLarge: TextStyle(
                            color: index == selectedIndex ? widget.selectedForegroundColor ?? Theme.of(context).cardColor : widget.unselectedForegroundColor ?? Theme.of(context).disabledColor,
                            fontSize: index == selectedIndex ? widget.selectedSize : widget.unselectedSize,
                          ),
                        ),
                      ),
                      child: widget.customBottomNavigationBarItems[index],
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class CustomBottomNavigationBarItems extends StatelessWidget {
  final IconData? icon;
  final String? label;
  const CustomBottomNavigationBarItems({
    Key? key,
    this.icon,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null)
          Flexible(
            child: Icon(
              icon,
            ),
          ),
        if (icon != null && label != null) const SizedBox(height: 2),
        if (label != null)
          Flexible(
            child: Text(
              label!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
      ],
    );
  }
}
