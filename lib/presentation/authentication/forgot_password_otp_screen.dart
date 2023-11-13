import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syla/controller/authentication_controller/otp_verification_controller.dart';
import 'package:syla/shared/Interceptors/jwt_inerceptor.dart';
import 'package:syla/shared/Styles/text_styles.dart';
import 'package:syla/shared/navigation/navigation.dart';

class ForgotPasswordOTPverificationScreen extends StatefulWidget {
  const ForgotPasswordOTPverificationScreen({super.key});

  @override
  State<ForgotPasswordOTPverificationScreen> createState() =>
      _ForgotPasswordOTPverificationScreenState();
}

class _ForgotPasswordOTPverificationScreenState
    extends State<ForgotPasswordOTPverificationScreen> {
  String? phoneNumber;
  bool init = true;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        initUser();
      },
    );

    super.initState();
  }

  initUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var phoneNumber = prefs.getString("phoneNumber");
    setState(() {
      if (init) {
        this.phoneNumber = phoneNumber;
        init = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider.value(
            value: OTPVerificationController(),
            child: Consumer<OTPVerificationController>(
                builder: (context, value, child) {
              return Stack(children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 7),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.black),
                                    borderRadius: BorderRadius.circular(8),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Center(
                                    child: IconButton(
                                        onPressed: () async {
                                          clearAll();
                                          NavigationService()
                                              .navigateTo('/forgot-password');
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
                                  "Forget password",
                                  style: titleStyle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 10,
                          ),
                          Text("Code has been sent to +216 $phoneNumber "),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 10,
                          ),
                          Pinput(
                              length: 6,
                              onCompleted: (pin) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString("pin", pin);
                                NavigationService()
                                    .navigateTo("/reset-password");
                              }
                              // value.sendVerificationCode(pin),
                              ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).size.height / 15,
                                left: 25,
                                right: 24),
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 48, // <-- Your height
                                child: ElevatedButton(
                                  onPressed: () {
                                    // controller.login();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  child: const Text(
                                    "Send verifiaction code",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]);
            })));
  }
}
