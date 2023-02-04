import 'package:flutter/material.dart';
import 'package:task_manager/models/task_status.dart';
import 'package:task_manager/style.dart';

Color colorAutoGenarated({required TaskStatus taskStatus}) {
  if (taskStatus.index == 0) return Colors.blueAccent;
  if (taskStatus.index == 1) return Colors.greenAccent;
  if (taskStatus.index == 2) return Colors.redAccent;
  if (taskStatus.index == 3) return Colors.purpleAccent;
  return defaultTextColorLight;
}

String textAutoGenarated({required TaskStatus taskStatus}) {
  if (taskStatus.index == 0) return "New";
  if (taskStatus.index == 1) return "Completed";
  if (taskStatus.index == 2) return "Canceled";
  if (taskStatus.index == 3) return "Progress";
  return "";
}
