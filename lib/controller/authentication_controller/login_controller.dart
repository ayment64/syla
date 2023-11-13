import 'package:flutter/material.dart';
import 'package:syla/shared/navigation/navigation.dart';
import 'package:syla/Services/auth_services.dart';

enum LoginStatus { init, loaded }

class LoginController extends ChangeNotifier {
  LoginStatus state = LoginStatus.init;
  String email = '';
  String password = '';
  bool rememberMe = false;
  String error = '';
  final TextEditingController emailController;
  final TextEditingController passwordController;
  LoginController({
    required this.passwordController,
    required this.emailController,
  });

  AuthServices authServices = AuthServices();

  Future login() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      LoginResponse response = await authServices.login(
          emailController.text, passwordController.text);
      if (response.success) {
        if (response.verified) {
          NavigationService().navigateAndReplace('/home');
          return;
        } else {
          NavigationService().navigateAndReplace('/verify-otp');
          return;
        }
      } else {
        error = response.message;
        notifyListeners();
        return false;
      }
    }
  }
}
