import 'package:flutter/material.dart';

// Container/Background Style
const MaterialColor primarySwatch = Colors.green;
const double defaultBoxHeight = 40;
const double defaultNavHeight = 60;
const double defaultPadding = 16;
const double defaultElevation = 2;

const List<BoxShadow> defaultShadow = [
  BoxShadow(
    color: Colors.black12,
    blurStyle: BlurStyle.inner,
    blurRadius: 0.5,
    offset: Offset(0, 2),
  ),
];

// Text Styles
const Color defaultTextColorLight = Colors.black;
const Color defaultTextColorDark = Colors.white;
const Color defaultTextShadow = Colors.grey;

const TextStyle title = TextStyle(
  color: defaultTextColorDark,
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

const TextStyle head1 = TextStyle(
  color: defaultTextColorLight,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

TextStyle subTitle1 = const TextStyle(
  color: defaultTextColorLight,
  fontSize: 12,
  fontWeight: FontWeight.bold,
);

TextStyle dateText = const TextStyle(
  color: defaultTextColorLight,
  fontSize: 10,
  fontWeight: FontWeight.bold,
);
