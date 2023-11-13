import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syla/controller/authentication_controller/register_controller.dart';
import 'package:syla/shared/widgets/input_feild.dart';
import '../../shared/Contents/text_values.dart';
import '../../shared/Styles/text_styles.dart';
import '../../shared/navigation/navigation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        body: ChangeNotifierProvider.value(
          value: RegisterController(
            emailController: emailController,
            firstNameController: firstNameController,
            lastNameController: lastNameController,
            phoneNumberController: phoneNumberController,
            passwordController: passwordController,
            confirmPasswordController: confirmPasswordController,
          ),
          child: Consumer<RegisterController>(
            builder: (BuildContext context, RegisterController controller,
                    Widget? _) =>
                SingleChildScrollView(
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
                                NavigationService().navigateTo('/login');
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
                        signupTitle,
                        style: titleStyle,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: deviceSize.height / 10,
                ),
                InputField(
                  key: const Key("1"),
                  controller: firstNameController,
                  placeHolder: firstnamePlaceHolder,
                  errorText: controller.registrationErrorScheme.firstName,
                  onChanged: controller.updateFirstName,
                ),
                InputField(
                  key: const Key("2"),
                  controller: lastNameController,
                  placeHolder: lastnamePlaceHolder,
                  errorText: controller.registrationErrorScheme.lastName,
                ),
                InputField(
                  key: const Key("3"),
                  controller: emailController,
                  placeHolder: emailPlaceHolder,
                  errorText: controller.registrationErrorScheme.email,
                ),
                InputField(
                  key: const Key("4"),
                  controller: phoneNumberController,
                  placeHolder: phoneNumberPlaceHolder,
                  errorText: controller.registrationErrorScheme.phoneNumber,
                ),
                // gender field

                InputField(
                  key: const Key("6"),
                  controller: passwordController,
                  placeHolder: passwordPlaceHolder,
                  obscureText: true,
                  isPasswordVisible: controller.isPasswordVisible,
                  suffixIconOnPressed: controller.togglePasswordVisibility,
                  errorText: controller.registrationErrorScheme.password,
                ),
                InputField(
                  key: const Key("7"),
                  controller: confirmPasswordController,
                  placeHolder: confirmPasswordPlaceHolder,
                  obscureText: true,
                  isPasswordVisible: controller.isConfirmPasswordVisible,
                  suffixIconOnPressed:
                      controller.toggleConfirmPasswordVisibility,
                  errorText: controller.registrationErrorScheme.confirmPassword,
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50.0, right: 24.0),
                  child: Row(
                    children: [
                      controller.error.isNotEmpty
                          ? Text(controller.error, style: errorTextStyle)
                          : Container(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 27.0, left: 24.0, right: 24.0),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.userRegistration();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text(
                          signUp,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 26,
                ),
              ],
            )),
          ),
        ));
  }
}
