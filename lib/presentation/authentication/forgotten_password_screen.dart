import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/authentication_controller/forgot_password_controller.dart';
import '../../shared/Contents/text_values.dart';
import '../../shared/Styles/text_styles.dart';
import '../../shared/navigation/navigation.dart';
import '../../shared/widgets/input_feild.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: ChangeNotifierProvider.value(
      value: ForgotPasswordController(
        phoneNumberController: phoneNumberController,
      ),
      child: Consumer<ForgotPasswordController>(builder: (BuildContext context,
          ForgotPasswordController controller, Widget? _) {
        if (controller.state == ForgotPasswordStates.inital) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            controller.initialize();
          });
        }
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
            Image.asset("assets/images/forgot-password.png"),
            SizedBox(
              height: deviceSize.height / 10,
            ),
            InputField(
              controller: controller.phoneNumberController,
              placeHolder: phoneNumberPlaceHolder,
              errorText: controller.error,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 27.0),
              child: SizedBox(
                  width: deviceSize.width * 0.9, // <-- Your width
                  height: 48, // <-- Your height
                  child: ElevatedButton(
                    onPressed: () async {
                      controller.toForgotPasswordOtpVerification();
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
