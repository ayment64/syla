import 'package:flutter/material.dart';
import 'package:syla/services/auth_services.dart';
import 'package:syla/shared/Interceptors/jwt_inerceptor.dart';
import 'package:syla/shared/navigation/navigation.dart';

enum ScreenState {
  initial,

  success,
  errorSendingCode,
  allgood
}

class OTPVerificationController extends ChangeNotifier {
  String error = '';
  ScreenState state = ScreenState.initial;
  AuthServices authServices = AuthServices();
  String phoneNumber = "";
  bool codeSent = false;

  Future<void> sendMessage() async {
    notifyListeners();
  }

  init() async {
    var user = await getUser();
    phoneNumber = user.phoneNumber ?? "58585858";
    state = ScreenState.allgood;
    codeSent = true;
    authServices.sendVerificatioSMSService(phoneNumber);
    notifyListeners();
  }

  void sendVerificationCode(String verificationCode) async {
    bool response = await authServices.sendVerificationCode(verificationCode);

    if (response) {
      state = ScreenState.success;
      NavigationService().navigateTo('/otp-success');
    } else {
      error = 'Error while sending message';
    }
    notifyListeners();
  }
}
