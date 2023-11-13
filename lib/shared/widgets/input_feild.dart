import 'package:flutter/material.dart';

import '../Styles/input_style.dart';
import '../Styles/text_styles.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String placeHolder;
  final String errorText;
  final bool obscureText;
  final bool isPasswordVisible;
  final Function()? suffixIconOnPressed;
  final Function(String)? onChanged;
  const InputField(
      {super.key,
      required this.controller,
      required this.placeHolder,
      required this.errorText,
      this.onChanged,
      this.obscureText = false,
      this.isPasswordVisible = false,
      this.suffixIconOnPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(75, 0, 0, 0),
                    blurRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: obscureText
                  ? TextField(
                      key: key,
                      controller: controller,
                      obscureText: !isPasswordVisible,
                      decoration: inputPrimaryStyle(
                          placeHolder,
                          !isPasswordVisible
                              ? IconButton(
                                  icon: const Icon(Icons.visibility),
                                  onPressed: suffixIconOnPressed,
                                )
                              : IconButton(
                                  icon: const Icon(Icons.visibility_off),
                                  onPressed: suffixIconOnPressed,
                                )))
                  : TextField(
                      controller: controller,
                      decoration: inputPrimaryStyle(placeHolder, null))),
        ),
        const SizedBox(
          height: 6,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 24.0),
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
    );
  }
}
