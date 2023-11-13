import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syla/controller/authentication_controller/register_controller.dart';
import 'package:syla/models/user_model.dart';
import 'package:syla/services/auth_services.dart';
import 'package:syla/shared/Interceptors/jwt_inerceptor.dart';
import 'package:syla/shared/contents/text_values.dart';
import 'package:syla/shared/navigation/navigation.dart';

enum ForgotPasswordStates { loading, loaded, inital }

class ForgotPasswordController extends ChangeNotifier {
  ForgotPasswordStates state = ForgotPasswordStates.inital;
  AuthServices authServices = AuthServices();

  RegisterRegex registerRegex = RegisterRegex();

  TextEditingController phoneNumberController = TextEditingController();
  ForgotPasswordController({required phoneNumberController});
  String error = "";
  final String phoneNumberRegex = r'^[0-9]{8}$';
  void setPhoneNumber(String phoneNumber) {
    // this.phoneNumber = phoneNumber;
    notifyListeners();
  }

  bool validatePhoneNumber() {
    if (registerRegex.validatePhoneNumber(phoneNumberController.text)) {
      error = "";
      notifyListeners();
      return true;
    } else {
      error = 'Invalid Phone Number';
      notifyListeners();
      return false;
    }
  }

  toForgotPasswordOtpVerification() async {
    if (validatePhoneNumber()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("phoneNumber", phoneNumberController.text);
      var response =
          await authServices.forgotPassword(phoneNumberController.text);
      if (response.success) {
        NavigationService().navigateAndReplace("/forgot-password-otp");
      } else {
        error = errors[response.message] ?? response.message;
        notifyListeners();
      }
    }
  }

  initialize() {
    phoneNumberController.addListener(() {
      if (validatePhoneNumber()) {
        var user = User(phoneNumber: phoneNumberController.text);
        setUser(user: json.encode(user.toJson()));
      }
    });
    state = ForgotPasswordStates.loaded;
    notifyListeners();
  }
}
