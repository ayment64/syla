import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syla/models/country_states.dart';

import '../../models/state_cities.dart';

enum BuillingAddressControllerState {
  initial,
  loading,
  loaded,
  addingBuillingAddress,
  error,
}

class BuillingAddressController extends ChangeNotifier {
  TextEditingController addressController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  BuillingAddressControllerState state = BuillingAddressControllerState.initial;
  BuillingAddressScheme errors = BuillingAddressScheme(
    address: '',
    city: '',
    state: '',
    zipCode: '',
    country: '',
    isDefault: false,
  );
  BuillingAddressController(
      {required this.addressController, required this.zipCodeController});

  ScrollController scrollController = ScrollController();
  List<BuillingAddressScheme> addressList = [];
  int isDefault = 0;
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  List<String> countries = [];
  List<String> states = [];
  List<String> cities = [];

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/countries.json');
    final data = await json.decode(response);

    for (var temp in data) {
      countries.add(temp.toString());
    }
  }

  Future<void> readCities() async {
    cities = [];
    final String response = await rootBundle.loadString('assets/cities.json');
    final data = await json.decode(response);
    var temp = StateCities.fromJson(data, selectedState!);
    for (var i in temp.cities!) {
      cities.add(i);
    }
  }

  Future<void> readStates() async {
    states = [];

    final String response = await rootBundle.loadString('assets/states.json');
    final data = await json.decode(response);
    var temp = CountryStates.fromJson(data, selectedCountry!);
    for (var i in temp.states!) {
      states.add(i.name!);
    }
  }

  setCountry(String country) async {
    if (selectedCountry != country) {
      selectedCountry = country;
      selectedState = null;
      selectedCity = null;
      await readStates();
      notifyListeners();
    }
  }

  setGeoState(String state) async {
    if (state != selectedState) {
      selectedState = state;
      selectedCity = null;
      readCities();
      notifyListeners();
    }
  }

  setCity(String state) async {
    selectedCity = state;
    notifyListeners();
  }

  void saveAddress() {
    if (validateAll()) {
      BuillingAddressScheme newAddress = BuillingAddressScheme(
        address: addressController.text,
        city: selectedCity ?? "",
        state: selectedState ?? "",
        zipCode: zipCodeController.text,
        country: selectedCountry ?? "",
        isDefault: false,
      );
      addressList.add(newAddress);
      saveAddressListToLocalStorage();
      state = BuillingAddressControllerState.initial;
      zipCodeController.text = "";
      addressController.text = "";
      notifyListeners();
    }
  }

  void getAdressListFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> addressListFromLocalStorage =
        prefs.getStringList('addressList') ?? [];
    for (var element in addressListFromLocalStorage) {
      addressList.add(BuillingAddressScheme.fromJson(element));
    }
    initDefaultIndex();
    state = BuillingAddressControllerState.loaded;
    notifyListeners();
  }

  void saveAddressListToLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> addressListToLocalStorage = [];
    for (var element in addressList) {
      addressListToLocalStorage.add(element.toJson());
    }
    prefs.setStringList('addressList', addressListToLocalStorage);
    // save address list to local storage
  }

  void initDefaultIndex() {
    for (var element in addressList) {
      if (element.isDefault) {
        isDefault = addressList.indexOf(element);
        continue;
      }
    }

    notifyListeners();
  }

  void setDefaultIndex(int index) {
    isDefault = index;
    for (var element in addressList) {
      if (addressList.indexOf(element) == index) {
        element.isDefault = true;
      } else {
        element.isDefault = false;
      }
    }
    saveAddressListToLocalStorage();
    notifyListeners();
  }

  void addBuillingAddress() {
    state = BuillingAddressControllerState.addingBuillingAddress;
    notifyListeners();
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 290,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void validateAddress() {
    if (addressController.text.isEmpty) {
      errors.address = 'Address is required';
    } else {
      errors.address = '';
    }
    notifyListeners();
  }

  void validateCity() {
    if (selectedCity == null || selectedCity!.isEmpty) {
      errors.city = 'City is required';
    } else {
      errors.city = '';
    }
    notifyListeners();
  }

  void validateState() {
    if (selectedState == null || selectedState!.isEmpty) {
      errors.state = 'State is required';
    } else {
      errors.state = '';
    }
    notifyListeners();
  }

  void validateZipCode() {
    if (zipCodeController.text.isEmpty) {
      errors.zipCode = 'Zip Code is required';
    } else {
      errors.zipCode = '';
    }
    notifyListeners();
  }

  void validateCountry() {
    if (selectedCountry == null || selectedCountry!.isEmpty) {
      errors.country = 'Country is required';
    } else {
      errors.country = '';
    }
    notifyListeners();
  }

  bool validateAll() {
    validateAddress();
    validateCity();
    validateState();
    validateZipCode();
    validateCountry();
    notifyListeners();
    if (errors.address.isEmpty &&
        errors.city.isEmpty &&
        errors.state.isEmpty &&
        errors.zipCode.isEmpty &&
        errors.country.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void initialize() async {
    addressList = [];
    state = BuillingAddressControllerState.loading;
    cities = [];
    states = [];
    countries = [];
    notifyListeners();
    addressController.text = '';
    selectedState = null;
    selectedCity = null;
    selectedCountry = null;
    zipCodeController.text = '';
    errors = BuillingAddressScheme(
      address: '',
      city: '',
      state: '',
      zipCode: '',
      country: '',
      isDefault: false,
    );

    addressController.addListener(() {
      validateAddress();
    });
    zipCodeController.addListener(() {
      validateZipCode();
    });
    await readJson();

    getAdressListFromLocalStorage();
  }
}

class BuillingAddressScheme {
  String address;
  String city;
  String state;
  String zipCode;
  String country;
  bool isDefault;
  BuillingAddressScheme({
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.isDefault = false,
  });

  String toJson() {
    return '{"address": "$address", "city": "$city", "state": "$state", "zipCode": "$zipCode", "country": "$country" , "isDefault": "$isDefault"}';
  }

  factory BuillingAddressScheme.fromJson(String json) {
    return BuillingAddressScheme(
      address: jsonDecode(json)['address'],
      city: jsonDecode(json)['city'],
      state: jsonDecode(json)['state'],
      zipCode: jsonDecode(json)['zipCode'],
      country: jsonDecode(json)['country'],
      isDefault: jsonDecode(json)['isDefault'] == 'true',
    );
  }
}
