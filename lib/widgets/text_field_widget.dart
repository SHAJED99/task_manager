import 'package:flutter/material.dart';
import 'package:task_manager/style.dart';

class CustomTextFormField extends StatefulWidget {
  final String? initialValue;

  final bool obscureText;
  final TextInputType keyboardType;
  final String hintText;
  final Color? color;
  final Color? errorColor;
  final Color? fillColor;
  final double height;
  final int maxLines;
  final int minLines;
  final double verticalPadding;
  final bool enabled;
  final bool readOnly;
  final InputBorder? enabledBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? focusedBorder;
  final TextEditingController? textEditingController;
  final Function(String? value)? validator;
  final Function(String? value)? onComplete;
  final Function(String value)? onChanged;
  final Iterable<String>? autofillHints;
  const CustomTextFormField({
    Key? key,
    this.obscureText = false,
    this.hintText = "",
    this.validator,
    this.errorColor,
    this.color,
    this.fillColor,
    this.keyboardType = TextInputType.text,
    this.height = defaultBoxHeight,
    this.onChanged,
    this.maxLines = 1,
    this.minLines = 1,
    this.verticalPadding = 16,
    this.enabled = true,
    this.readOnly = false,
    this.enabledBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.focusedBorder,
    this.textEditingController,
    this.initialValue,
    this.onComplete,
    this.autofillHints,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late String hintText;
  bool error = false;
  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = widget.textEditingController ?? TextEditingController();
    hintText = widget.hintText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(textSelectionTheme: TextSelectionThemeData(selectionColor: (widget.color ?? Theme.of(context).primaryColor).withOpacity(0.3))),
      child: SizedBox(
        height: widget.height < 0 ? null : widget.height,
        child: TextFormField(
          autofillHints: widget.autofillHints,
          initialValue: widget.initialValue,
          controller: textEditingController,
          maxLines: widget.minLines > widget.maxLines ? widget.minLines : widget.maxLines,
          minLines: widget.minLines,
          textAlignVertical: TextAlignVertical.center,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          onEditingComplete: () {
            if (widget.onComplete != null) widget.onComplete!(textEditingController.text);
          },
          onTap: () {
            if (error) {
              hintText = widget.hintText;
              error = false;
            }
            if (mounted) setState(() {});
          },
          onChanged: (value) {
            // print(value);
            if (widget.onChanged != null) widget.onChanged!(value);
            if (error) {
              hintText = widget.hintText;
              error = false;
            }
            if (mounted) setState(() {});
          },
          validator: (value) {
            if (widget.validator == null || widget.validator!(value) == null) return null;
            error = true;
            textEditingController.clear();
            hintText = widget.validator!(value);
            if (mounted) setState(() {});
            return "";
          },
          style: TextStyle(
            color: widget.color ?? Theme.of(context).primaryColor,
          ),
          cursorColor: error ? widget.errorColor ?? Theme.of(context).colorScheme.error : widget.color ?? Theme.of(context).primaryColor,
          decoration: InputDecoration(
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: error ? widget.errorColor ?? Theme.of(context).colorScheme.error : Colors.transparent),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: widget.height < 0 ? widget.verticalPadding : 0, horizontal: 8),
            errorStyle: const TextStyle(height: 0),
            hintStyle: TextStyle(color: error ? widget.errorColor ?? Theme.of(context).colorScheme.error : (widget.color ?? Theme.of(context).hintColor).withOpacity(0.3)),
            hintText: hintText,
            enabledBorder: widget.enabledBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: error ? widget.errorColor ?? Theme.of(context).colorScheme.error : Colors.transparent),
                ),
            errorBorder: widget.errorBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: error ? widget.errorColor ?? Theme.of(context).colorScheme.error : Colors.transparent),
                ),
            focusedErrorBorder: widget.focusedErrorBorder ??
                OutlineInputBorder(borderSide: BorderSide(width: 1, color: error ? widget.errorColor ?? Theme.of(context).colorScheme.error : widget.color ?? Theme.of(context).primaryColor)),
            focusedBorder: widget.focusedBorder ??
                OutlineInputBorder(borderSide: BorderSide(width: 1, color: error ? widget.errorColor ?? Theme.of(context).colorScheme.error : widget.color ?? Theme.of(context).primaryColor)),
            fillColor: widget.fillColor ?? Theme.of(context).cardColor,
            filled: true,
          ),
        ),
      ),
    );
  }
}
