import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/data_controller.dart';
import 'package:task_manager/models/task_status.dart';
import 'package:task_manager/style.dart';
import 'package:task_manager/widgets/app_bar_widget.dart';
import 'package:task_manager/widgets/background_image_widget.dart';
import 'package:task_manager/widgets/button_widget.dart';
import 'package:task_manager/widgets/text_field_widget.dart';

class AddNewTask extends StatelessWidget {
  AddNewTask({super.key});
  final Data data = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: CustomIconButton(
          padding: defaultPadding / 2,
          size: defaultPadding * 2.5,
          onTap: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: defaultTextColorDark,
          ),
        ),
      ),
      body: BackgroundImage(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding),
              constraints: const BoxConstraints(maxWidth: 300),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Headline
                    Text("Add New Task", style: title.copyWith(color: defaultTextColorLight)),
                    const SizedBox(height: defaultPadding * 2),
                    // Subject Input Field
                    CustomTextFormField(
                      textEditingController: _title,
                      hintText: "Subject",
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value != null && value.isEmpty) return "Enter subject";
                      },
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    CustomTextFormField(
                      textEditingController: _description,
                      hintText: "Description",
                      minLines: 10,
                      height: -1,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value != null && value.isEmpty) return "Enter description";
                      },
                    ),
                    const SizedBox(height: defaultPadding),
                    // Submit Button
                    CustomElevatedButton(
                      borderRadius: defaultPadding / 4,
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        if (await data.createTask(title: _title.text, description: _description.text)) Get.back();
                      },
                      onLoading: const SizedBox(height: defaultBoxHeight, child: AspectRatio(aspectRatio: 1, child: CircularProgressIndicator(color: defaultTextColorDark))),
                      child: const Icon(Icons.arrow_circle_right_outlined, color: defaultTextColorDark),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
