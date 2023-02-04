import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/constant_variable.dart';
import 'package:task_manager/controllers/data_controller.dart';
import 'package:task_manager/services/auto_genarated_service.dart';
import 'package:task_manager/style.dart';
import 'package:task_manager/widgets/card_widget.dart';

class StatusCountTiles extends StatelessWidget {
  StatusCountTiles({super.key, this.height = defaultNavHeight, this.show = true});

  final Data data = Get.find();
  final bool show;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 4),
      child: GetBuilder<Data>(
        builder: (context) => TweenAnimationBuilder(
          duration: defaultAnimationDuration,
          tween: Tween<double>(begin: 0, end: show ? height : 0),
          builder: (context, value, child) {
            return Row(
              children: data.tasks.entries
                  .map((e) => Expanded(
                        child: CustomCard(
                          alignment: Alignment.centerLeft,
                          height: value,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.value.length.toString(), style: title.copyWith(color: defaultTextColorLight)),
                                  Text(textAutoGenarated(taskStatus: e.key), style: subTitle1),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
