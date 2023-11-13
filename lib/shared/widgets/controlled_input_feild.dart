import 'package:flutter/material.dart';

import '../Styles/input_style.dart';
import '../Styles/text_styles.dart';

class ControlledInputField extends StatelessWidget {
  final TextEditingController setValue;
  final Function()? suffixIconOnPressed;
  final bool isPasswordVisible;
  final String placeHolder;
  final EdgeInsets padding;
  final EdgeInsets errorPadding;
  final double widthRatio;
  final String errorText;
  final TextInputType textInputType;
  const ControlledInputField(
      {super.key,
      required this.setValue,
      required this.placeHolder,
      required this.errorText,
      this.widthRatio = 1.0,
      this.textInputType = TextInputType.text,
      this.isPasswordVisible = false,
      this.padding = const EdgeInsets.only(left: 24.0, right: 24.0),
      this.errorPadding = const EdgeInsets.only(left: 35.0, right: 24.0),
      this.suffixIconOnPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * widthRatio,
      child: Column(
        children: [
          Padding(
            padding: padding,
            child: TextField(
                keyboardType: textInputType,
                controller: setValue,
                decoration: inputSecondaryStyle(placeHolder, null)),
          ),
          const SizedBox(
            height: 6,
          ),
          Padding(
            padding: errorPadding,
            child: Row(
              children: [
                errorText.isNotEmpty
                    ? Flexible(child: Text(errorText, style: errorTextStyle))
                    : Container(),
              ],
            ),
          ),
          const SizedBox(
            height: 6,
          ),
        ],
      ),
    );
  }
}
