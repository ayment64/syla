import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HomeController extends ChangeNotifier {
  int index = 1;
  String title = 'Usage';
  List<String> titles = [
    'Usage',
    'Coverage',
    'Profile',
  ];
  PersistentTabController controller = PersistentTabController(initialIndex: 1);
  void setTitle(index) {
    title = titles[index];
    notifyListeners();
  }

  void setIndex(int index) {
    index = index;
    controller.index = index;
    notifyListeners();
  }
}
