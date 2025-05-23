import 'package:delivery_flutter_app/common/const/colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final FormFieldSetter? onSaved;
  final FormFieldValidator? validatior;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.errorText,
    this.onSaved,
    this.obscureText = false,
    this.autofocus = false,
    this.validatior,
  });

  @override
  Widget build(BuildContext context) {
    var baseBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: INPUT_BORDER_COLOR, width: 1.0),
    );

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      obscureText: obscureText,
      autofocus: autofocus,
      onSaved: onSaved,
      validator: validatior,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: const TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 14,
        ),
        fillColor: INPUT_BG_COLOR,
        filled: true,
        border: baseBorder,
        enabledBorder: baseBorder,
      ),
    );
  }
}
