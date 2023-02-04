import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/data_controller.dart';
import 'package:task_manager/screens/signup_screen.dart';
import 'package:task_manager/services/check_validation.dart';
import 'package:task_manager/style.dart';
import 'package:task_manager/widgets/background_image_widget.dart';
import 'package:task_manager/widgets/button_widget.dart';
import 'package:task_manager/widgets/text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.email, this.password});
  final String? email;
  final String? password;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _tcEmail = TextEditingController();
  final TextEditingController _tcPassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Data data = Get.find();
  bool isEnable = true;

  @override
  void initState() {
    super.initState();
    // Run if email and password is taken from previous screen
    requestLogin();
  }

  Future<void> requestLogin() async {
    if (widget.email == null || widget.password == null) return;
    isEnable = false;
    await data.loginRequest(email: widget.email ?? "", password: widget.password ?? "");
  }

  // place CircularProgressIndicator when loading
  Widget onLoadingPlacement() {
    return const SizedBox(height: defaultBoxHeight, child: AspectRatio(aspectRatio: 1, child: CircularProgressIndicator(color: defaultTextColorDark)));
  }

  // Make previous screen password to star
  String passwordToStar(String password) {
    String star = "";
    for (var i = 0; i < password.length; i++) {
      star = "$star•";
    }
    return star;
  }

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
                  Text("Get Started With", style: title.copyWith(color: defaultTextColorLight)),
                  const SizedBox(height: defaultPadding * 2),
                  // Email Input Field
                  CustomTextFormField(
                    textEditingController: _tcEmail,
                    autofillHints: const [AutofillHints.email],
                    hintText: widget.email ?? "Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null) return null;
                      if (value.isEmpty) return "Enter email";
                      if (!isValidEmail(email: value)) return "Enter valid email address";
                    },
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  // Password Input Field
                  CustomTextFormField(
                    textEditingController: _tcPassword,
                    hintText: widget.password != null ? passwordToStar(widget.password!) : "Password",
                    obscureText: true,
                    validator: (value) {
                      if (value == null) return null;
                      if (value.isEmpty) return "Enter password";
                      if (!isValidPassword(password: value)) return "Enter valid password";
                    },
                  ),
                  const SizedBox(height: defaultPadding),
                  // Submit Button
                  CustomElevatedButton(
                    borderRadius: defaultPadding / 4,
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      await data.loginRequest(email: _tcEmail.text, password: _tcPassword.text);
                    },
                    onLoading: onLoadingPlacement(),
                    child: isEnable ? const Icon(Icons.arrow_circle_right_outlined, color: defaultTextColorDark) : onLoadingPlacement(),
                  ),
                  const SizedBox(height: defaultPadding * 4),
                  // Forget Password Button
                  Center(
                    child: CustomTextButton(
                      textStyle: subTitle1.copyWith(color: defaultTextShadow),
                      child: const Text("Forget Password?", textAlign: TextAlign.center),
                    ),
                  ),
                  Center(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: [
                        // Don't have account?
                        Text(
                          "Don't have account?",
                          textAlign: TextAlign.center,
                          style: head1.copyWith(color: defaultTextColorLight.withOpacity(0.6)),
                        ),
                        // Sign up Button
                        CustomTextButton(
                          textStyle: head1.copyWith(color: Theme.of(context).primaryColor),
                          onPressed: () => Get.off(() => SignupScreen()),
                          child: const Text("Sign up"),
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
