import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syla/presentation/home/home_sub_screens/change_password_modal.dart';
import 'package:syla/services/user_services.dart';
import 'package:syla/models/user_model.dart';
import '../../shared/Interceptors/jwt_inerceptor.dart';

import 'package:device_info/device_info.dart';

import '../../shared/navigation/navigation.dart';

enum ProfileStates {
  initial,
  loading,
  loaded,
  error,
}

class ProfileController extends ChangeNotifier {
  User user = User();
  UserServices userServices = UserServices();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController operatorController = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController IMEIController = TextEditingController();
  bool isEditing = false;
  // ignore: non_constant_identifier_names

  ProfileStates state = ProfileStates.initial;

  void refreshUser() async {
    state = ProfileStates.loading;
    user = await userServices.refreshUser();
    notifyListeners();
  }

  setIsEditing() {
    isEditing = !isEditing;
    if (!isEditing) {
      updateProfile();
    }
    notifyListeners();
  }

  updateProfile() async {
    user.firstName = firstNameController.text;
    user.lastName = lastNameController.text;
    user.email = emailController.text;
    user.phoneNumber = phoneNumberController.text;
    user.firstName = firstNameController.text;
    await userServices.updateUser(user);
  }

  Future<String> getServiceOperator() async {
    if (Platform.isAndroid) {
      return "Android";
    } else if (Platform.isIOS) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.utsname.nodename;
    } else {
      return "Service provider or operator not available.";
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    NavigationService().navigateAndReplace('/login');
    return;
  }

  Future<void> showChangePasswordDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: const [
                Center(
                    child: Text(
                  'Chnage Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff384454),
                      fontWeight: FontWeight.w700,
                      fontSize: 22),
                )),
              ],
            ),
            content: SizedBox(
                width: 600,
                child: ChangePasswordScreen(
                  onClose: () {
                    Navigator.of(context).pop();
                    showSuccessDialog(context, "Password updated successfully");
                  },
                )),
          );
        });
  }

  Future<void> showSuccessDialog(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset("assets/images/success-purshase.png"),
                  const SizedBox(
                    height: 20,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: message,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff27AE60))),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      Center(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xff27AE60),
                            border: Border.all(
                                color: const Color(0xff27AE60), width: 2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: TextButton(
                            child: const Padding(
                              padding: EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                              ),
                              child: Text('Close',
                                  style: TextStyle(
                                      color: Color(0xffffffff),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12)),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: const [
              Center(
                  child: Text(
                'Logout',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xffF15F22),
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              )),
              Divider(
                color: Colors.grey,
                thickness: 1,
              )
            ],
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          content: SingleChildScrollView(
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Are you sure you want to logout',
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border: Border.all(
                            color: const Color(0xff1F84C7), width: 2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TextButton(
                        child: const Padding(
                          padding: EdgeInsets.only(
                            left: 15.0,
                            right: 15.0,
                          ),
                          child: Text('Close',
                              style: TextStyle(
                                  color: Color(0xff1F84C7),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xff1F84C7),
                        border: Border.all(
                            color: const Color(0xff1F84C7), width: 2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TextButton(
                        child: const Padding(
                          padding: EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                          ),
                          child: Text('Yes, logout',
                              style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12)),
                        ),
                        onPressed: () {
                          logout();
                          Navigator.of(context).pop;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void initialize() async {
    state = ProfileStates.loading;
    getServiceOperator();

    user = await getUser();
    firstNameController.text = user.firstName ?? '';
    lastNameController.text = user.lastName ?? '';
    emailController.text = user.email ?? '';
    phoneNumberController.text = user.phoneNumber ?? '';
    operatorController.text = "ooredoo";
    IMEIController.text = "36-336633";

    state = ProfileStates.loaded;
    notifyListeners();
  }
}

bool compareUsers(User user1, User user2) {
  // Convert the users to JSON representation
  var json1 = user1.toJson();
  var json2 = user2.toJson();

  // Iterate over each field of the user object
  for (var field in json1.keys) {
    // Get the field values from both users
    var value1 = json1[field];
    var value2 = json2[field];

    // Compare the field values
    if (value1 != value2) {
      return false; // Fields are not equal
    }
  }

  return true; // All fields are equal
}
