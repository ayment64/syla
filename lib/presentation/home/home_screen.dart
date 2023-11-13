import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syla/controller/home_controller.dat/home_controller.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:syla/presentation/home/home_sub_screens/coverage_screen.dart';
import 'package:syla/presentation/home/home_sub_screens/profile_screen.dart';
import 'package:syla/presentation/home/home_sub_screens/usage_screen.dart';

import '../../shared/Styles/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  List<Widget> _buildScreens() {
    return [
      const UsageScreen(),
      const CouvertureScreen(),
      const ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.data_usage_outlined),
        title: ("Usage"),
        activeColorPrimary: Color(blue),
        inactiveColorPrimary: Colors.grey,
        activeColorSecondary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.travel_explore_outlined),
        title: ("Coverage"),
        activeColorPrimary: Color(blue),
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person_outline),
        title: ("Profile"),
        activeColorPrimary: Color(blue),
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: HomeController(),
      child: Consumer<HomeController>(
        builder: (context, value, child) {
          return Scaffold(
              body: PersistentTabView(
            context,
            controller: value.controller,

            screens: _buildScreens(),
            items: _navBarsItems(),
            onItemSelected: (s) => value.setTitle(s),
            confineInSafeArea: true,
            backgroundColor: Colors.white, // Default is Colors.white.
            handleAndroidBackButtonPress: true, // Default is true.
            resizeToAvoidBottomInset:
                true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            stateManagement: true, // Default is true.
            hideNavigationBarWhenKeyboardShows:
                true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(10.0),
              colorBehindNavBar: Colors.white,
            ),
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: const ItemAnimationProperties(
              // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: const ScreenTransitionAnimation(
              // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle
                .style10, // Choose the nav bar style with this property.
          ));
        },
      ),
    );
  }
}
