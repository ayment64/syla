import 'package:flutter/material.dart';
import 'package:syla/services/user_services.dart';
import 'package:syla/shared/Styles/input_style.dart';
import 'package:syla/shared/Styles/text_styles.dart';
import 'package:syla/shared/contents/text_values.dart';

class ChangePasswordScreen extends StatefulWidget {
  final Function onClose;
  const ChangePasswordScreen({super.key, required this.onClose});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  UserServices userServices = UserServices();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String oldPasswordError = "";
  String passwordError = "";
  String confirmPasswordError = "";
  String serviceError = "";
  final String passwordRegex =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$';
  bool validatePassword() {
    return RegExp(passwordRegex).hasMatch(passwordController.text);
  }

  bool validateConfirmPassword() {
    return passwordController.text == confirmPasswordController.text;
  }

  bool validateOldPassword() {
    return oldPasswordController.text.isNotEmpty;
  }

  checkPassword() {
    if (!validatePassword()) {
      setState(() {
        passwordError =
            "Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, and one digit.";
      });
    } else if (passwordError.isNotEmpty) {
      setState(() {
        passwordError = "";
      });
    }
  }

  checkOldPassword() {
    if (!validateOldPassword()) {
      setState(() {
        oldPasswordError = "Old password is required";
      });
    } else if (oldPasswordError.isNotEmpty) {
      setState(() {
        oldPasswordError = "";
      });
    }
  }

  checkConfirmPassword() {
    if (!validateConfirmPassword()) {
      setState(() {
        confirmPasswordError = 'Password does not match';
      });
    } else if (confirmPasswordError.isNotEmpty) {
      setState(() {
        confirmPasswordError = '';
      });
    }
  }

  validateAll() {
    checkOldPassword();
    checkPassword();
    checkConfirmPassword();
  }

  changePassword() async {
    if (validatePassword() &&
        validateConfirmPassword() &&
        validateOldPassword()) {
      var response = await userServices.changePassword(
          oldPasswordController.text,
          passwordController.text,
          confirmPasswordController.text);
      if (response.success) {
        widget.onClose();
      } else {
        setState(() {
          serviceError = errors[response.message] ?? "Something went wrong";
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: decoration(oldpasswordPlaceHolder)),
        ),
        oldPasswordError.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Flexible(
                        child: Text(oldPasswordError, style: errorTextStyle)),
                  ],
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: decoration(newPasswordPlaceHolder)),
        ),
        passwordError.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Flexible(child: Text(passwordError, style: errorTextStyle)),
                  ],
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: decoration(confirmNewPasswordPlaceHolder)),
        ),
        confirmPasswordError.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Flexible(
                        child:
                            Text(confirmPasswordError, style: errorTextStyle)),
                  ],
                ),
              )
            : Container(),
        serviceError.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Flexible(child: Text(serviceError, style: errorTextStyle)),
                  ],
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    10.0), // Rounded rectangle with radius 10.0
              ),
              backgroundColor: const Color(0xFF4197D0), // Fill color: #4197D0
              // Font color: White
              elevation: 0, // No shadow
              padding: const EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 16.0), // Padding
            ),
            onPressed: () {
              validateAll();
              changePassword();
            },
            child: const Text(
              'Save changes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        )
      ]),
    );
  }
}
