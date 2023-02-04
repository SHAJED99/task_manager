import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/data_controller.dart';
import 'package:task_manager/models/task_status.dart';
import 'package:task_manager/style.dart';
import 'package:task_manager/widgets/task_tile_widget.dart';

class TaskDetailsScreen extends StatelessWidget {
  TaskDetailsScreen({super.key, required this.taskStatus});
  final TaskStatus taskStatus;
  final Data data = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GetBuilder<Data>(builder: (controller) {
        return ListView.builder(
          itemCount: data.tasks[taskStatus]!.length + 1,
          itemBuilder: (context, index) {
            if (index < data.tasks[taskStatus]!.length) {
              return TaskTile(task: data.tasks[taskStatus]![index]);
            } else {
              // Add extra space under the list
              return const SizedBox(height: defaultNavHeight);
            }
          },
        );
      }),
    );
  }
}
