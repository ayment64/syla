import 'package:flutter/material.dart';

InputDecoration inputPrimaryStyle(String labeltext, IconButton? suffixIcon) {
  const color = Color(0xfffafafa);
  return InputDecoration(
    border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(50))),
    labelText: labeltext,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    fillColor: color,
    filled: true,
    suffixIcon: suffixIcon,
    contentPadding: const EdgeInsets.fromLTRB(30, 20, 20, 20),
  );
}

InputDecoration inputSecondaryStyle(String labeltext, IconButton? suffixIcon) {
  const color = Color(0xfffafafa);
  return InputDecoration(
    border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    labelText: labeltext,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    fillColor: color,
    filled: true,
    suffixIcon: suffixIcon,
    contentPadding: const EdgeInsets.fromLTRB(30, 20, 20, 20),
  );
}

InputDecoration decoration(String labelText) {
  return InputDecoration(
    filled: true,
    fillColor: const Color(0xFFFAFAFA), // Fill color: #FAFAFA
    label: Text(labelText),
    border: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(10.0), // Rounded rectangle with radius 10.0
      borderSide: const BorderSide(
        color: Color(0xFFE2E2E2), // Border color: #E2E2E2
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(10.0), // Rounded rectangle with radius 10.0
      borderSide: const BorderSide(
        color: Color(0xFFE2E2E2), // Border color: #E2E2E2
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(10.0), // Rounded rectangle with radius 10.0
      borderSide: const BorderSide(
        color: Color(0xFFE2E2E2), // Border color: #E2E2E2
      ),
    ),
    hintStyle: const TextStyle(
      color: Color(0xFFD9D9D9), // Font color: #D9D9D9
    ),
  );
}
