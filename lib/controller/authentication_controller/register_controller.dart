import 'package:flutter/material.dart';
import 'package:syla/Services/auth_services.dart';
import 'package:syla/shared/contents/text_values.dart';
import 'package:syla/shared/navigation/navigation.dart';

class RegisterController extends ChangeNotifier {
  RegisterRegex registerRegex = RegisterRegex();
  AuthServices authServices = AuthServices();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  String error = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  RegisterController({
    required this.emailController,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneNumberController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  RegistrationScheme registrationScheme = RegistrationScheme(
    email: '',
    firstName: '',
    lastName: '',
    phoneNumber: '',
    password: '',
    confirmPassword: '',
  );

  RegistrationScheme registrationErrorScheme = RegistrationScheme(
    email: '',
    firstName: '',
    lastName: '',
    phoneNumber: '',
    password: '',
    confirmPassword: '',
  );
  void updateFirstName(String value) {
    firstNameController.text = value;
    notifyListeners();
  }

  bool validateEmail() {
    if (registerRegex.validateEmail(emailController.text)) {
      registrationErrorScheme.email = '';
      notifyListeners();
      return true;
    } else {
      registrationErrorScheme.email = 'Invalid Email';
      notifyListeners();
      return false;
    }
  }

  bool validateFirstName() {
    if (firstNameController.text.isNotEmpty) {
      registrationErrorScheme.firstName = '';
      notifyListeners();
      return true;
    } else {
      registrationErrorScheme.firstName = 'First Name is required';
      notifyListeners();
      return false;
    }
  }

  bool validateLastName() {
    if (lastNameController.text.isNotEmpty) {
      registrationErrorScheme.lastName = '';
      notifyListeners();
      return true;
    } else {
      registrationErrorScheme.lastName = 'Last Name is required';
      notifyListeners();
      return false;
    }
  }

  bool validatePhoneNumber() {
    if (registerRegex.validatePhoneNumber(phoneNumberController.text)) {
      registrationErrorScheme.phoneNumber = '';
      notifyListeners();
      return true;
    } else {
      registrationErrorScheme.phoneNumber = 'Invalid Phone Number';
      notifyListeners();
      return false;
    }
  }

  bool validatePassword() {
    if (registerRegex.validatePassword(passwordController.text)) {
      registrationErrorScheme.password = '';
      notifyListeners();
      return true;
    } else {
      registrationErrorScheme.password =
          "Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, and one digit.";
      notifyListeners();
      return false;
    }
  }

  bool validateConfirmPassword() {
    if (passwordController.text == confirmPasswordController.text) {
      registrationErrorScheme.confirmPassword = '';
      notifyListeners();
      return true;
    } else {
      registrationErrorScheme.confirmPassword = 'Password does not match';
      notifyListeners();
      return false;
    }
  }

  bool validateAll() {
    validateEmail();
    validateFirstName();
    validateLastName();
    validatePhoneNumber();
    validatePassword();
    validateConfirmPassword();
    if (validateEmail() &&
        validateFirstName() &&
        validateLastName() &&
        validatePhoneNumber() &&
        validatePassword() &&
        validateConfirmPassword()) {
      return true;
    } else {
      return false;
    }
  }

  void clearAll() {
    registrationScheme.email = '';
    registrationScheme.firstName = '';
    registrationScheme.lastName = '';
    registrationScheme.phoneNumber = '';
    registrationScheme.password = '';
    registrationScheme.confirmPassword = '';
    registrationErrorScheme.email = '';
    registrationErrorScheme.firstName = '';
    registrationErrorScheme.lastName = '';
    registrationErrorScheme.phoneNumber = '';
    registrationErrorScheme.password = '';
    registrationErrorScheme.confirmPassword = '';
    notifyListeners();
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  // timer to reset the error message after 3 seconds
  void resetError() {
    Future.delayed(const Duration(seconds: 3), () {
      error = '';
      notifyListeners();
    });
  }

  Future userRegistration() async {
    if (validateAll()) {
      registrationScheme = RegistrationScheme(
        email: emailController.text,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        phoneNumber: phoneNumberController.text,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      );
      var response = await authServices.registerUser(registrationScheme);
      if (response.success) {
        NavigationService().navigateTo('/verify-otp');
      } else {
        error = errors[response.message] ?? "Something went wrong";
        resetError();
        notifyListeners();
      }
    }
  }
}

class RegisterRegex {
  final String emailRegex = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
  final String passwordRegex =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$';
  final String phoneNumberRegex = r'^[0-9]{8}$';

  bool validateEmail(String email) {
    return RegExp(emailRegex).hasMatch(email);
  }

  bool validatePassword(String password) {
    return RegExp(passwordRegex).hasMatch(password);
  }

  bool validatePhoneNumber(String phoneNumber) {
    return RegExp(phoneNumberRegex).hasMatch(phoneNumber);
  }
}

class RegistrationScheme {
  String email = '';
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String password = '';
  String confirmPassword = '';

  RegistrationScheme({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
  });
}

class RegistrationResponse {
  String token = '';
  String message = '';
  RegistrationResponse({required this.token, required this.message});
}

// set token to shared preferences
