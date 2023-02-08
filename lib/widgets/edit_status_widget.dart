import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/data_controller.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/models/task_status_model.dart';
import 'package:task_manager/services/auto_genarated_service.dart';
import 'package:task_manager/style.dart';
import 'package:task_manager/widgets/button_widget.dart';
import 'package:task_manager/widgets/card_widget.dart';

class EditStatus extends StatefulWidget {
  const EditStatus({super.key, required this.task});
  final Task task;

  @override
  State<EditStatus> createState() => _EditStatusState();
}

class _EditStatusState extends State<EditStatus> {
  TaskStatus? currentValue;
  final Data data = Get.find();
  List<TaskStatus> tasklist = [TaskStatus.New, TaskStatus.Completed, TaskStatus.Canceled, TaskStatus.Progress];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding / 4),
        child: CustomCard(
          constraints: const BoxConstraints(maxWidth: 300),
          height: 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text("Title: ${widget.task.title ?? "Unknown"}", style: head1)),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<TaskStatus>(
                          isExpanded: true,
                          value: currentValue ?? widget.task.status,
                          items: tasklist
                              .map((e) => DropdownMenuItem<TaskStatus>(
                                    value: e,
                                    child: Text(
                                      e.name,
                                      style: subTitle1.copyWith(fontWeight: FontWeight.normal),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() => currentValue = value);
                          },
                        ),
                      ),
                    ),
                    CustomElevatedButton(
                      width: 100,
                      height: defaultBoxHeight,
                      enableBackgroundColor: currentValue == null || currentValue == widget.task.status
                          ? colorAutoGenarated(taskStatus: widget.task.status).withOpacity(0.8)
                          : colorAutoGenarated(taskStatus: widget.task.status),
                      isEnable: currentValue == null || currentValue == widget.task.status ? false : true,
                      onLoading: const SizedBox(height: defaultBoxHeight, child: AspectRatio(aspectRatio: 1, child: CircularProgressIndicator(color: defaultTextColorDark))),
                      onPressed: () async {
                        if (currentValue == null || currentValue == widget.task.status) return;
                        await data.statusChange(task: widget.task, currentStatus: currentValue ?? TaskStatus.New);
                        Get.back();
                      },
                      child: Text(
                        "Update",
                        style: subTitle1.copyWith(color: defaultTextColorDark),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
