// ignore_for_file: must_be_immutable, lines_longer_than_80_chars

import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    required this.controller,
    required this.validator,
    required this.hintText,
    super.key,
    this.obScureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.isEnabled = true,
    this.onChanged,
    this.onTap,
    this.textInputType,
    this.minLines = 1,
    this.maxLines = 5,
    this.fillColor = Colors.transparent,
    this.focusNode,
    this.borderRadius = 10,
  });
  final TextEditingController controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obScureText;
  final String hintText;
  final bool? isEnabled;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final int minLines;
  final int maxLines;
  final TextInputType? textInputType;
  final Color? fillColor;
  final double borderRadius;
  final FocusNode ?focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      focusNode: focusNode,
      controller: controller,
      obscureText: obScureText,
      enabled: isEnabled ?? true,
      keyboardType: textInputType ?? TextInputType.text,
      textInputAction: TextInputAction.next,
      minLines: minLines,
      maxLines: maxLines,  
      onTap: onTap,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        fillColor: fillColor,
        enabledBorder: OutlineInputBorder(
            borderSide: Theme.of(context)
                .inputDecorationTheme
                .enabledBorder!
                .borderSide,
            borderRadius: BorderRadius.circular(borderRadius)),
        focusedBorder: OutlineInputBorder(
            borderSide: Theme.of(context)
                .inputDecorationTheme
                .focusedBorder!
                .borderSide,
            borderRadius: BorderRadius.circular(borderRadius)),
        border: OutlineInputBorder(
            borderSide:
                Theme.of(context).inputDecorationTheme.border!.borderSide,
            borderRadius: BorderRadius.circular(borderRadius)),
        errorBorder: OutlineInputBorder(
            borderSide:
                Theme.of(context).inputDecorationTheme.errorBorder!.borderSide,
            borderRadius: BorderRadius.circular(borderRadius)),
        // enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
        // border: Theme.of(context).inputDecorationTheme.border,
        // disabledBorder: Theme.of(context).inputDecorationTheme.disabledBorder,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 22),
      ),
    );
  }
}
