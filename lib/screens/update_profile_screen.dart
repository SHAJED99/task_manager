import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/data_controller.dart';
import 'package:task_manager/models/user_data_model.dart';
import 'package:task_manager/services/check_validation.dart';
import 'package:task_manager/style.dart';
import 'package:task_manager/widgets/app_bar_widget.dart';
import 'package:task_manager/widgets/background_image_widget.dart';
import 'package:task_manager/widgets/button_widget.dart';
import 'package:task_manager/widgets/image_picker_input_field_widget.dart';
import 'package:task_manager/widgets/text_field_widget.dart';

class UpdateProfile extends StatelessWidget {
  UpdateProfile({super.key});

  final Data data = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController tcEmail = TextEditingController();
  final TextEditingController tcFirstName = TextEditingController();
  final TextEditingController tcLastName = TextEditingController();
  final TextEditingController tcMobile = TextEditingController();
  final TextEditingController tcPassword = TextEditingController();
  final TextEditingController tcPhoto = TextEditingController();
  final UserData userData = UserData();

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
                  Text("Update Profile", style: title.copyWith(color: defaultTextColorLight)),
                  const SizedBox(height: defaultPadding * 2),
                  // Image Picker
                  CustomImagePickerField(
                    textEditingController: tcPhoto,
                    validator: (value) {
                      // return "va";
                    },
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  // email Input Field
                  CustomTextFormField(
                    textEditingController: tcEmail,
                    hintText: "Email: ${data.userData.email ?? ""}",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null) return null;
                      if (value.isNotEmpty && !isValidEmail(email: value)) return "Enter valid email";
                      if (value.isNotEmpty) userData.email = value;
                    },
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  // First name input field
                  CustomTextFormField(
                    textEditingController: tcFirstName,
                    hintText: "First Name: ${data.userData.firstName ?? ""}",
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null) return null;
                      if (value.isNotEmpty) userData.firstName = value;
                      // if (value != null && value.isEmpty) return "Enter subject";
                    },
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  // Last name input field
                  CustomTextFormField(
                    textEditingController: tcLastName,
                    hintText: "Last Name: ${data.userData.lastName ?? ""}",
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null) return null;
                      if (value.isNotEmpty) userData.lastName = value;
                      // if (value != null && value.isEmpty) return "Enter subject";
                    },
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  // mobile name input field
                  CustomTextFormField(
                    textEditingController: tcMobile,
                    hintText: "Mobile: ${data.userData.mobile ?? ""}",
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null) return null;
                      if (value.isNotEmpty) userData.mobile = value;
                      // if (value != null && value.isEmpty) return "Enter subject";
                    },
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  // Passward input field
                  CustomTextFormField(
                    textEditingController: tcPassword,
                    hintText: "Password",
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (value) {
                      // if (value != null && value.isEmpty) return "Enter subject";
                    },
                  ),
                  const SizedBox(height: defaultPadding),
                  // Submit button
                  CustomElevatedButton(
                    borderRadius: defaultPadding / 4,
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      if (await data.updateProfile(file: tcPhoto.text.isEmpty ? null : File(tcPhoto.text), password: tcPassword.text.isEmpty ? null : tcPassword.text, ud: userData)) Get.back();
                    },
                    onLoading: const SizedBox(height: defaultBoxHeight, child: AspectRatio(aspectRatio: 1, child: CircularProgressIndicator(color: defaultTextColorDark))),
                    child: const Icon(Icons.arrow_circle_right_outlined, color: defaultTextColorDark),
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
