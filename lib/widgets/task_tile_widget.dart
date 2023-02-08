import 'package:flutter/material.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/services/auto_genarated_service.dart';
import 'package:task_manager/style.dart';
import 'package:task_manager/widgets/button_widget.dart';
import 'package:task_manager/widgets/card_widget.dart';
import 'package:task_manager/widgets/delete_confirmation_widget.dart';
import 'package:task_manager/widgets/edit_status_widget.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 4),
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding / 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title ?? "Unknown", style: head1),
              const SizedBox(height: defaultPadding / 2),
              Text(task.description ?? "Unknown", style: subTitle1),
              const SizedBox(height: defaultPadding / 2),
              Text("Date: ${task.createdDate!.replaceAll("-", "/")}", style: dateText),
              const SizedBox(height: defaultPadding / 2),
              Row(
                children: [
                  CustomElevatedButton(
                      enableBackgroundColor: colorAutoGenarated(taskStatus: task.status),
                      isEnable: false,
                      height: -1,
                      child: Text(textAutoGenarated(taskStatus: task.status), style: subTitle1.copyWith(color: defaultTextColorDark))),
                  const Spacer(),
                  CustomIconButton(
                    onTap: () => showDialog(context: context, builder: (context) => EditStatus(task: task)),
                    size: defaultBoxHeight,
                    padding: defaultPadding / 2,
                    icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                  ),
                  CustomIconButton(
                      onTap: () => showDialog(context: context, builder: (context) => DeleteConfirmataion(task: task)),
                      size: defaultBoxHeight,
                      padding: defaultPadding / 2,
                      icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
