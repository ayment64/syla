import 'package:flutter/material.dart';
import 'package:syla/shared/navigation/navigation.dart';
import '../../shared/Styles/text_styles.dart';

class VerificationSuccessScreen extends StatelessWidget {
  const VerificationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
          Image.asset('assets/images/success.png'),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            child: Text(
              'Verified Successfully',
              textAlign: TextAlign.center,
              style: successTitleStyle,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3.3,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 27.0, left: 24.0, right: 24.0),
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 48, // <-- Your height
                child: ElevatedButton(
                  onPressed: () {
                    NavigationService().navigateTo("/home");
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                )),
          ),
        ]));
  }
}
