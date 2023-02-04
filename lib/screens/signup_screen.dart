import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/data_controller.dart';
import 'package:task_manager/models/user_data_model.dart';
import 'package:task_manager/screens/login_screen.dart';
import 'package:task_manager/screens/wrapper_screen.dart';
import 'package:task_manager/services/check_validation.dart';
import 'package:task_manager/style.dart';
import 'package:task_manager/widgets/background_image_widget.dart';
import 'package:task_manager/widgets/button_widget.dart';
import 'package:task_manager/widgets/text_field_widget.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _tcEmail = TextEditingController();
  final TextEditingController _tcFirstName = TextEditingController();
  final TextEditingController _tcLastName = TextEditingController();
  final TextEditingController _tcMobileNumber = TextEditingController();
  final TextEditingController _tcPassword = TextEditingController();
  final Data data = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundImage(
        child: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding),
            constraints: const BoxConstraints(maxWidth: 300),
            // Login form
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Headline
                  Text("Join With Us", style: title.copyWith(color: defaultTextColorLight)),
                  const SizedBox(height: defaultPadding * 2),
                  // Email Input Field
                  CustomTextFormField(
                    textEditingController: _tcEmail,
                    autofillHints: const [AutofillHints.email],
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null) return null;
                      if (value.isEmpty) return "Enter email";
                      if (!isValidEmail(email: value)) return "Enter valid email address";
                    },
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  // First Name Input Field
                  CustomTextFormField(
                    textEditingController: _tcFirstName,
                    hintText: "First Name",
                    validator: (value) {
                      if (value != null && value.isEmpty) return "Enter your first name";
                    },
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  // Last Name Input Field
                  CustomTextFormField(
                    textEditingController: _tcLastName,
                    hintText: "Last Name",
                    validator: (value) {
                      if (value != null && value.isEmpty) return "Enter your last name";
                    },
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  // Mobile Input Field
                  CustomTextFormField(
                    textEditingController: _tcMobileNumber,
                    hintText: "Mobile",
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isEmpty) return "Enter your mobile number";
                    },
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  // Password Input Field
                  CustomTextFormField(
                    textEditingController: _tcPassword,
                    hintText: "Password",
                    obscureText: true,
                    validator: (value) {
                      if (value != null && value.isEmpty) return "Enter password";
                    },
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  // Submit Button
                  CustomElevatedButton(
                    borderRadius: defaultPadding / 4,
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      bool res = await data.signupRequest(
                        password: _tcPassword.text,
                        userData: UserData(
                          email: _tcEmail.text,
                          firstName: _tcFirstName.text,
                          lastName: _tcLastName.text,
                          mobile: _tcMobileNumber.text,
                        ),
                      );

                      if (res) Get.off(() => Wrapper(email: _tcEmail.text, password: _tcPassword.text));
                    },
                    onLoading: const SizedBox(height: defaultBoxHeight, child: AspectRatio(aspectRatio: 1, child: CircularProgressIndicator(color: defaultTextColorDark))),
                    child: const Icon(Icons.arrow_circle_right_outlined, color: defaultTextColorDark),
                  ),
                  const SizedBox(height: defaultPadding * 4),
                  Center(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: [
                        // Have account?
                        Text(
                          "Have account?",
                          textAlign: TextAlign.center,
                          style: head1.copyWith(color: defaultTextColorLight.withOpacity(0.6)),
                        ),
                        // Sign in Button
                        CustomTextButton(
                          textStyle: head1.copyWith(color: Theme.of(context).primaryColor),
                          onPressed: () => Get.off(() => const LoginScreen()),
                          child: const Text("Sign in"),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
