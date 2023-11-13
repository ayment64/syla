import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syla/controller/authentication_controller/register_controller.dart';

import 'package:syla/services/auth_services.dart';
import 'package:syla/shared/contents/text_values.dart';
import 'package:syla/shared/navigation/navigation.dart';

class ResetPasswordController extends ChangeNotifier {
  AuthServices authServices = AuthServices();
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  ResetPasswordController(
      {required this.passwordController,
      required this.confirmPasswordController});
  RegisterRegex registerRegex = RegisterRegex();
  String passwordError = "";
  String confirmPasswordError = "";
  bool validatePassword() {
    if (registerRegex.validatePassword(passwordController.text)) {
      passwordError = '';
      notifyListeners();
      return true;
    } else {
      passwordError =
          "Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, and one digit.";
      notifyListeners();
      return false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  bool validateConfirmPassword() {
    if (passwordController.text == confirmPasswordController.text) {
      confirmPasswordError = '';
      notifyListeners();
      return true;
    } else {
      confirmPasswordError = 'Password does not match';
      notifyListeners();
      return false;
    }
  }

  bool validateAll() {
    return validatePassword() && validateConfirmPassword();
  }

  resetPassword() async {
    if (validateAll()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var phoneNumber = prefs.getString("phoneNumber");
      var pin = prefs.getString("pin");

      var response = await authServices.resetPasswordService(
          phoneNumber: phoneNumber ?? "",
          verificationCode: pin ?? "123456",
          password: passwordController.text,
          confirmPassword: confirmPasswordController.text);
      if (response.success) {
        NavigationService().navigateAndClearStack("/login");
      } else {
        confirmPasswordError = errors[response.message]!;
      }
    }
  }
}
