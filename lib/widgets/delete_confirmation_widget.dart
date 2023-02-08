import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/data_controller.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/style.dart';
import 'package:task_manager/widgets/button_widget.dart';
import 'package:task_manager/widgets/card_widget.dart';

class DeleteConfirmataion extends StatelessWidget {
  DeleteConfirmataion({super.key, required this.task});
  final Task task;
  final Data data = Get.find();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding / 4),
        child: CustomCard(
          constraints: const BoxConstraints(maxWidth: 300),
          height: 90,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text("Do you really want to delete \"${task.title ?? "Unknown"}\"?", style: head1)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          "No",
                          style: subTitle1.copyWith(
                            color: defaultTextColorDark,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    Expanded(
                        child: CustomElevatedButton(
                      enableBackgroundColor: Theme.of(context).colorScheme.error,
                      onLoading: const AspectRatio(aspectRatio: 1, child: CircularProgressIndicator(color: defaultTextColorDark)),
                      onPressed: () async {
                        await data.statusChange(task: task);
                        Get.back();
                      },
                      child: Text("Yes", style: subTitle1.copyWith(color: defaultTextColorDark)),
                    )),
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
