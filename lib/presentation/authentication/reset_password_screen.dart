import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syla/controller/authentication_controller/reset_password_controller.dart';
import 'package:syla/shared/Styles/text_styles.dart';
import 'package:syla/shared/navigation/navigation.dart';
import '../../shared/Contents/text_values.dart';
import '../../shared/widgets/input_feild.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: ChangeNotifierProvider.value(
      value: ResetPasswordController(
          passwordController: passwordController,
          confirmPasswordController: confirmPasswordController),
      child: Consumer<ResetPasswordController>(builder: (BuildContext context,
          ResetPasswordController controller, Widget? _) {
        return SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: deviceSize.height / 7,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 35,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                      shape: BoxShape.rectangle,
                    ),
                    child: Center(
                      child: IconButton(
                          onPressed: () {
                            NavigationService().navigateAndClearStack('/login');
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 22,
                          )),
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    forgotPasswordTitle,
                    style: titleStyle,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: deviceSize.height / 10,
            ),
            Image.asset("assets/images/change-password.png"),
            SizedBox(
              height: deviceSize.height / 10,
            ),
            InputField(
              key: const Key("6"),
              controller: passwordController,
              placeHolder: passwordPlaceHolder,
              obscureText: true,
              isPasswordVisible: controller.isPasswordVisible,
              suffixIconOnPressed: controller.togglePasswordVisibility,
              errorText: controller.passwordError,
            ),
            InputField(
              key: const Key("7"),
              controller: confirmPasswordController,
              placeHolder: confirmPasswordPlaceHolder,
              obscureText: true,
              isPasswordVisible: controller.isConfirmPasswordVisible,
              suffixIconOnPressed: controller.toggleConfirmPasswordVisibility,
              errorText: controller.confirmPasswordError,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 27.0),
              child: SizedBox(
                  width: deviceSize.width * 0.9, // <-- Your width
                  height: 48, // <-- Your height
                  child: ElevatedButton(
                    onPressed: () async {
                      controller.resetPassword();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      confrim,
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                  )),
            ),
          ],
        ));
      }),
    ));
  }
}
