import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:syla/presentation/authentication/forgot_password_otp_screen.dart';
import 'package:syla/presentation/authentication/reset_password_screen.dart';
import 'package:syla/presentation/authentication/verification_success_screen.dart';
import 'package:syla/presentation/home/home_screen.dart';
import 'package:syla/presentation/home/home_sub_screens/builling_address_screen.dart';
import 'package:syla/presentation/home/home_sub_screens/payement_method_screen.dart';
import 'package:syla/shared/navigation/navigation.dart';
import 'package:syla/Presentation/Authentication/forgotten_password_screen.dart';
import 'package:syla/Presentation/Authentication/login_screen.dart';
import 'package:syla/Presentation/Authentication/otp_verification_screen.dart';
import 'package:syla/Presentation/Authentication/register_screen.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

final Map<String, WidgetBuilder> routes = {
  '/home': (BuildContext context) => const HomeScreen(),
  '/register': (BuildContext context) => const RegisterScreen(),
  '/login': (BuildContext context) => const LoginScreen(),
  '/forgot-password': (BuildContext context) => const ForgotPasswordScreen(),
  '/forgot-password-otp': (BuildContext context) =>
      const ForgotPasswordOTPverificationScreen(),
  '/verify-otp': (BuildContext context) => const OTPverificationScreen(),
  '/otp-success': (BuildContext context) => const VerificationSuccessScreen(),
  '/addresses': (BuildContext context) => const BuillingAddressScreen(),
  '/payment-methods': (BuildContext context) => const PayementMethodScreen(),
  '/reset-password': (BuildContext context) => const ResetPasswordScreen()
  // Add other routes as needed
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      title: 'Syla Roaming',
      routes: routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
