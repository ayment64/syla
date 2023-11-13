import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syla/controller/home_controller.dat/profile_controller.dart';
import 'package:syla/shared/contents/text_values.dart';
import 'package:syla/shared/extentions/string_extention.dart';

import 'package:syla/shared/Styles/colors.dart';
import 'package:syla/shared/Styles/text_styles.dart';
import 'package:syla/shared/navigation/navigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        centerTitle: true,
        leading: null,
      ),
      body: Center(
        child: ChangeNotifierProvider.value(
          value: ProfileController(),
          child: Consumer<ProfileController>(
            builder: (context, value, child) {
              if (value.state == ProfileStates.initial) {
                value.initialize();
              }
              if (value.state == ProfileStates.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (value.state == ProfileStates.loaded) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // * image and name *
                      ProfileContainer(
                        size: size,
                        value: value,
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Color(blue),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                    value.user.firstName
                                            ?.substring(0, 1)
                                            .toUpperCase() ??
                                        '',
                                    style: imagePlaceHolderTextStyle),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30.0, 0, 30, 10),
                            child: Text(
                              "${value.user.firstName?.toCapitalized()} ${value.user.lastName?.toCapitalized()} ",
                              style: titleStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 10, 15, 0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      value.setIsEditing();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    child: Center(
                                        child: Text(value.isEditing
                                            ? "Save Changes"
                                            : "Edit Profile")),
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15.0, 20, 15, 0),
                                child: Text(
                                  "User Information",
                                  style: usageProfileSectionTitle,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Divider(
                              color: Color(primaryColor),
                              thickness: 0.5,
                              height: 20,
                            ),
                          ),
                          ProfileInput(
                            controller: value.firstNameController,
                            placeholder: firstnamePlaceHolder,
                            hasSuffixIcon: false,
                            enabled: value.isEditing,
                            iconData: Icons.person_outlined,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Divider(
                              color: Color(primaryColor),
                              thickness: 0.5,
                              height: 10,
                            ),
                          ),
                          ProfileInput(
                            controller: value.lastNameController,
                            placeholder: lastnamePlaceHolder,
                            hasSuffixIcon: false,
                            enabled: value.isEditing,
                            iconData: Icons.person_outlined,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Divider(
                              color: Color(primaryColor),
                              thickness: 0.5,
                              height: 5,
                            ),
                          ),
                          ProfileInput(
                            controller: value.emailController,
                            placeholder: emailPlaceHolder,
                            hasSuffixIcon: false,
                            enabled: value.isEditing,
                            iconData: Icons.email_outlined,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ]),
                      ),

                      // * change password *
                      ProfileContainer(
                        size: size,
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: InkWell(
                            onTap: () {
                              value.showChangePasswordDialog(context);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  color: Color(primaryColor),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Change Password",
                                  style: usageProfileSectionTitle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // * device information *
                      ProfileContainer(
                        size: size,
                        value: value,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15.0, 20, 15, 0),
                              child: Text(
                                "Device information",
                                style: usageProfileSectionTitle,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: Divider(
                                color: Color(primaryColor),
                                thickness: 0.5,
                                height: 10,
                              ),
                            ),
                            ProfileInput(
                              controller: value.operatorController,
                              placeholder: operatorPlaceholder,
                              hasSuffixIcon: false,
                              iconData: Icons.phone_android_outlined,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: Divider(
                                color: Color(primaryColor),
                                thickness: 0.5,
                                height: 10,
                              ),
                            ),
                            ProfileInput(
                              controller: value.phoneNumberController,
                              placeholder: phoneNumberPlaceHolder,
                              iconData: Icons.phone_android_outlined,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: Divider(
                                color: Color(primaryColor),
                                thickness: 0.5,
                                height: 5,
                              ),
                            ),
                            ProfileInput(
                              controller: value.IMEIController,
                              placeholder: imeiPlaceholder,
                              hasSuffixIcon: false,
                              iconData: Icons.email_outlined,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      // * payment method *
                      ProfileContainer(
                        size: size,
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: InkWell(
                            onTap: () => NavigationService()
                                .navigateTo("/payment-methods"),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.payment_outlined,
                                  color: Color(primaryColor),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Payment Method",
                                  style: usageProfileSectionTitle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // * builling information *
                      ProfileContainer(
                        size: size,
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: InkWell(
                            onTap: () {
                              NavigationService().navigateTo("/addresses");
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.home_outlined,
                                  color: Color(primaryColor),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Billing Address",
                                  style: usageProfileSectionTitle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // * logout *
                      ProfileContainer(
                        size: size,
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: InkWell(
                            onTap: () {
                              value.showLogoutDialog(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.logout_outlined,
                                  color: Color(errorColor),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Logout",
                                  style: logoutProfileSectionTitle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                );
              }
              return const Center(
                child: Text('initial'),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ProfileInput extends StatefulWidget {
  ProfileInput(
      {super.key,
      required this.controller,
      required this.placeholder,
      required this.iconData,
      this.enabled = false,
      this.hasSuffixIcon = true});
  TextEditingController controller;
  String placeholder;
  IconData iconData;
  bool hasSuffixIcon;
  bool enabled;

  @override
  State<ProfileInput> createState() => _ProfileInputState();
}

class _ProfileInputState extends State<ProfileInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: InputDecorator(
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          prefix: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.iconData,
                color: Color(primaryColor),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(widget.placeholder),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        child: TextField(
            enabled: widget.enabled,
            controller: widget.controller,
            decoration: const InputDecoration(
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            )),
      ),
    );
  }
}

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({
    super.key,
    required this.size,
    required this.child,
    required this.value,
  });
  final ProfileController value;
  final Size size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
      child: Container(
          width: size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: child),
    );
  }
}
