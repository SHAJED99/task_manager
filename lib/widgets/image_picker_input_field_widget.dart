import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/style.dart';
import 'package:task_manager/widgets/text_field_widget.dart';

class CustomImagePickerField extends StatefulWidget {
  const CustomImagePickerField({
    super.key,
    this.textEditingController,
    this.path,
    this.height = defaultBoxHeight,
    this.clipBehavior = Clip.antiAlias,
    this.constraints,
    this.boxShadow,
    this.backgroundColor,
    this.validator,
    this.hintText = "Press photo button to add",
  });

  final TextEditingController? textEditingController;
  final String? path;
  final double height;
  final Clip clipBehavior;
  final BoxConstraints? constraints;
  final List<BoxShadow>? boxShadow;
  final Color? backgroundColor;
  final Function(String? value)? validator;
  final String hintText;
  @override
  State<CustomImagePickerField> createState() => _CustomImagePickerFieldState();
}

class _CustomImagePickerFieldState extends State<CustomImagePickerField> {
  late TextEditingController textEditingController;
  bool error = false;
  bool focus = false;
  XFile? _image;

  @override
  void initState() {
    super.initState();
    textEditingController = widget.textEditingController ?? TextEditingController();
  }

  Future<void> getImage() async {
    _image = await ImagePicker().pickImage(source: ImageSource.camera);
    textEditingController.text = _image != null ? _image!.path : "";
    if (mounted) setState(() {});
  }

  Color _color() {
    if (focus) {
      return Theme.of(context).primaryColor;
    } else if (error) {
      return Theme.of(context).colorScheme.error;
    } else {
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) {
        if (value) {
          focus = true;
          error = false;
        } else {
          focus = false;
        }
        setState(() {});
      },
      child: Container(
        height: widget.height,
        clipBehavior: widget.clipBehavior,
        constraints: widget.constraints,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(defaultPadding / 4),
          boxShadow: widget.boxShadow,
          border: Border.all(width: 1, strokeAlign: BorderSide.strokeAlignCenter, color: _color()),
        ),
        child: Row(
          children: [
            Material(
              borderRadius: BorderRadius.circular(defaultPadding / 4),
              clipBehavior: Clip.antiAlias,
              color: Theme.of(context).hintColor,
              child: InkWell(
                onTap: () => getImage(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      image: _image == null
                          ? null
                          : DecorationImage(
                              image: FileImage(File(_image!.path)),
                              fit: BoxFit.cover,
                              opacity: 0.7,
                              onError: (exception, stackTrace) => Container(),
                            )),
                  child: Text(
                    "Photo",
                    style: TextStyle(
                      color: Theme.of(context).cardColor,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: CustomTextFormField(
                  textEditingController: textEditingController,
                  hintText: widget.hintText,
                  readOnly: true,
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.transparent)),
                  focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.transparent)),
                  errorBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.transparent)),
                  validator: (value) {
                    if (widget.validator == null || widget.validator!(value) == null) return null;
                    error = true;
                    textEditingController.clear();
                    if (mounted) setState(() {});
                    return widget.validator!(value);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
