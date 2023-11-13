import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'coverage_controller.dart';

enum UsageState { initial, loading, loaded }

class UsageController extends ChangeNotifier {
  ScrollController scrollController = ScrollController();
  List<OfferScheme> activeOffers = [];
  UsageState usageState = UsageState.initial;

  getActiveOfferFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    activeOffers = [];
    List<String>? activeOfferFromLocalStorage =
        prefs.getStringList('activeOffers');
    if (activeOfferFromLocalStorage != null) {
      for (var element in activeOfferFromLocalStorage) {
        activeOffers.add(OfferScheme.fromJson(element));
      }
    }
    usageState = UsageState.loaded;
    notifyListeners();
  }

  initilize() {
    getActiveOfferFromLocalStorage();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      getActiveOfferFromLocalStorage();
    });
  }
}
