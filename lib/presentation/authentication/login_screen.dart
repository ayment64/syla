import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syla/Models/user_model.dart';
import 'package:syla/controller/authentication_controller/login_controller.dart';

import 'package:syla/shared/Styles/input_style.dart';
import 'package:syla/shared/Styles/text_styles.dart';
import 'package:syla/shared/contents/text_values.dart';
import '../../shared/navigation/navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkUserVerificationAndRedirect() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');

    bool isLoggedIn = prefs.containsKey('user');

    if (isLoggedIn && userData != null) {
      final user = User.fromJson(jsonDecode(userData));
      if (user.firstName == null) {
        return;
      }
      if (user.verified == true) {
        // Redirect to home screen
        NavigationService().navigateTo('/home');
      } else {
        NavigationService().navigateTo('/verify-otp');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkUserVerificationAndRedirect();
    return;
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider.value(
        value: LoginController(
            emailController: emailController,
            passwordController: passwordController),
        child: Consumer<LoginController>(builder:
            (BuildContext context, LoginController controller, Widget? _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: deviceSize.height / 7,
                ),
                const LoginTitle(title: loginTitle),
                SizedBox(
                  height: deviceSize.height / 10,
                ),
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
                    child: TextField(
                        controller: emailController,
                        decoration: inputPrimaryStyle(emailPlaceHolder, null)),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
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
                    child: TextField(
                        controller: passwordController,
                        decoration:
                            inputPrimaryStyle(passwordPlaceHolder, null),
                        obscureText: true),
                  ),
                ),
                controller.error != ""
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(27, 12, 26, 0),
                        child: Text(
                            errors[controller.error] ?? "Something went wrong",
                            style: errorTextStyle),
                      )
                    : Container(),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 27.0, left: 24.0, right: 24.0),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 48, // <-- Your height
                      child: ElevatedButton(
                        onPressed: () {
                          controller.login();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text(
                          signIn,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextButton(
                  onPressed: () {
                    NavigationService().navigateTo('/forgot-password');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: const Text(forgotPassword),
                ),
                SizedBox(
                  height: deviceSize.height / 4.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(dontHaveAccount),
                    TextButton(
                      onPressed: () {
                        NavigationService().navigateTo('/register');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      child: const Text(signUp),
                    )
                  ],
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}

class LoginTitle extends StatelessWidget {
  final String title;
  const LoginTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0),
      child: Text(
        title,
        style: titleStyle,
      ),
    );
  }
}
