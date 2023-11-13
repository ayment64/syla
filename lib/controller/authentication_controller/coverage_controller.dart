import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syla/controller/authentication_controller/builling_address_controller.dart';
import 'package:syla/controller/authentication_controller/payment_method_controller.dart';
import 'package:syla/models/user_model.dart';
import 'package:syla/shared/Interceptors/jwt_inerceptor.dart';

import '../../models/country_states.dart';
import '../../models/state_cities.dart';

enum CoverageState { initial, loading, loaded, selectPaymentMehod, error }

enum PaymentMethod { balance, paypal, creditCard }

enum AdressState { addAddress, chooseAddress }

enum PaymentMethodSatates { adding, showing }

class CoverageController extends ChangeNotifier {
  PayementMethodType payementMethodType = PayementMethodType.creditCard;
  PaymentMethodSatates paymenetMethodState = PaymentMethodSatates.showing;
  CoverageState state = CoverageState.initial;
  PaymentMethod payementMethod = PaymentMethod.balance;
  AdressState adressState = AdressState.addAddress;
  List<OfferScheme> offers = [
    OfferScheme(
        country: "Tunisia",
        id: "0",
        internetQuotaInMb: 2048000,
        voiceQuotaInMinutes: 0,
        smsQuota: 200,
        offerName: "Offer 1",
        price: 1200),
    OfferScheme(
        country: "Tunisia",
        offerName: "Offer 2",
        id: "1",
        internetQuotaInMb: 2048,
        voiceQuotaInMinutes: 0,
        smsQuota: 200,
        price: 12),
    OfferScheme(
        country: "Tunisia",
        id: "2",
        offerName: "Offer 3",
        internetQuotaInMb: 2048,
        voiceQuotaInMinutes: 0,
        smsQuota: 200,
        price: 12),
    OfferScheme(
        country: "Tunisia",
        id: "12",
        offerName: "Offer 3",
        internetQuotaInMb: 2048,
        voiceQuotaInMinutes: 0,
        smsQuota: 200,
        price: 12),
    OfferScheme(
        country: "Maroco",
        id: "3",
        internetQuotaInMb: 2048,
        voiceQuotaInMinutes: 0,
        smsQuota: 200,
        offerName: "Offer 1",
        price: 12),
    OfferScheme(
        country: "Maroco",
        offerName: "Offer 2",
        id: "4",
        internetQuotaInMb: 2048,
        voiceQuotaInMinutes: 0,
        smsQuota: 200,
        price: 12),
    OfferScheme(
        country: "Maroco",
        id: "5",
        offerName: "Offer 3",
        internetQuotaInMb: 2048,
        voiceQuotaInMinutes: 0,
        smsQuota: 200,
        price: 12),
    OfferScheme(
        country: "France",
        id: "6",
        internetQuotaInMb: 2048,
        voiceQuotaInMinutes: 0,
        smsQuota: 200,
        offerName: "Offer 1",
        price: 12),
    OfferScheme(
        country: "France",
        offerName: "Offer 2",
        id: "7",
        internetQuotaInMb: 2048,
        voiceQuotaInMinutes: 0,
        smsQuota: 200,
        price: 12),
    OfferScheme(
        country: "France",
        id: "8",
        offerName: "Offer 3",
        internetQuotaInMb: 2048,
        voiceQuotaInMinutes: 0,
        smsQuota: 200,
        price: 12),
    OfferScheme(
        country: "Algeria",
        id: "9",
        internetQuotaInMb: 2048,
        voiceQuotaInMinutes: 0,
        smsQuota: 200,
        offerName: "Offer 1",
        price: 12),
    OfferScheme(
        country: "Algeria",
        offerName: "Offer 2",
        id: "10",
        internetQuotaInMb: 2048,
        voiceQuotaInMinutes: 0,
        smsQuota: 200,
        price: 12),
    OfferScheme(
        country: "Algeria",
        id: "11",
        offerName: "Offer 3",
        internetQuotaInMb: 2048,
        voiceQuotaInMinutes: 0,
        smsQuota: 200,
        price: 12),
  ];
  List<OfferScheme> activeOffers = [];
  Map<String, List<OfferScheme>> offersByCountry = {};
  String selectedCountry = "";
  CreditCardScheme selectedPaymentMethod = CreditCardScheme(
    cardNumber: '',
    cardHolderName: '',
    cvv: '',
    expiryMonth: '',
    expiryYear: '',
  );
  List<OfferScheme> selectedCountryOffers = [];
  List<CreditCardScheme> creditCardList = [];
  List<BuillingAddressScheme> addressList = [];
  OfferScheme selectedOffer = OfferScheme(
      country: "",
      id: "",
      internetQuotaInMb: 0,
      voiceQuotaInMinutes: 0,
      smsQuota: 0,
      offerName: "",
      price: 0);
  CreditCardScheme selectedCreditCard = CreditCardScheme(
    cardNumber: '',
    cardHolderName: '',
    cvv: '',
    expiryMonth: '',
    expiryYear: '',
  );
  BuillingAddressScheme selectedAddress = BuillingAddressScheme(
    address: '',
    city: '',
    country: '',
    zipCode: '',
    state: '',
  );

  String? selectedCountryField;
  String? selectedState;
  String? selectedCity;
  List<String> countries = [];
  List<String> states = [];
  List<String> cities = [];

  TextEditingController addressController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController expiryMonthController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryYearController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  CoverageController({
    required this.addressController,
    required this.zipCodeController,
    required this.cardHolderNameController,
    required this.expiryMonthController,
    required this.cardNumberController,
    required this.expiryYearController,
    required this.cvvController,
    required this.emailController,
  });
  String emailError = "";
  User user = User();
  BuillingAddressScheme errors = BuillingAddressScheme(
    address: '',
    city: '',
    state: '',
    zipCode: '',
    country: '',
    isDefault: false,
  );
  CreditCardScheme errorsHandler = CreditCardScheme(
    cardNumber: '',
    cardHolderName: '',
    expiryMonth: '',
    expiryYear: '',
    cvv: '',
    isDefault: false,
  );
  setCoverageState(CoverageState newState) {
    state = newState;
    paymenetMethodState = PaymentMethodSatates.showing;
    errorsHandler = CreditCardScheme(
      cardNumber: '',
      cardHolderName: '',
      cvv: '',
      expiryMonth: '',
      expiryYear: '',
    );
    notifyListeners();
  }

  setAddressState(AdressState newState) {
    adressState = newState;
    notifyListeners();
  }

  chosePaymentMethod(CreditCardScheme method, PaymentMethod type) {
    selectedPaymentMethod = method;
    payementMethod = type;
    state = CoverageState.loaded;
    notifyListeners();
  }

  resetActiveOffersInLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('activeOffers', []);
  }

  setCountry(String country) async {
    if (selectedCountry != country) {
      selectedCountryField = country;
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

  Future<void> readJson() async {
    countries = [];
    final String response =
        await rootBundle.loadString('assets/countries.json');
    final data = await json.decode(response);

    for (var temp in data) {
      countries.add(temp.toString());
    }
    notifyListeners();
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
    var temp = CountryStates.fromJson(data, selectedCountryField!);
    for (var i in temp.states!) {
      states.add(i.name!);
    }
  }

  void saveAddress() {
    if (validateAll()) {
      BuillingAddressScheme newAddress = BuillingAddressScheme(
        address: addressController.text,
        city: selectedCity ?? '',
        state: selectedState ?? '',
        zipCode: zipCodeController.text,
        country: selectedCountryField ?? '',
        isDefault: false,
      );
      selectedAddress = newAddress;
      addressList.add(newAddress);
      selectedCountryField = null;
      selectedCity = null;
      selectedState = null;
      countries = [];
      states = [];
      cities = [];
      toChooseAddress();
      saveAddressListToLocalStorage();
      addressController.text = "";
      zipCodeController.text = "";

      notifyListeners();
    }
  }

  changePayementMethodType(PayementMethodType? type) {
    if (type == null) return;
    payementMethodType = type;
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

  void addPayementMethod() {
    paymenetMethodState = PaymentMethodSatates.adding;
    notifyListeners();
  }

  // set selected address from default address or from address list
  initSelectedAddress() {
    selectedAddress = addressList[0];
    for (var address in addressList) {
      if (address.isDefault) {
        selectedAddress = address;

        break;
      }
    }

    notifyListeners();
  }

  setSelectedAdress(BuillingAddressScheme address) {
    selectedAddress = address;
    notifyListeners();
  }

  initSelectedCreditCard() {
    for (var creditCard in creditCardList) {
      if (creditCard.isDefault) {
        selectedCreditCard = creditCard;
        break;
      }
    }
    notifyListeners();
  }

  int balance = 0;
  setSelectedCountry(String country) {
    selectedCountry = country;
    selectedCountryOffers = offersByCountry[country]!;
    notifyListeners();
  }

  resetSelectedCountry() {
    selectedCountry = "";
    selectedCountryOffers = [];
    notifyListeners();
  }

  void groupOffersByCountry() {
    for (var offer in offers) {
      if (offersByCountry.containsKey(offer.country)) {
        offersByCountry[offer.country]!.add(offer);
      } else {
        offersByCountry[offer.country] = [offer];
      }
    }
    state = CoverageState.loaded;
    notifyListeners();
  }

  resetSelectedOffer() {
    payementMethodType = PayementMethodType.creditCard;
    paymenetMethodState = PaymentMethodSatates.showing;
    state = CoverageState.initial;
    payementMethod = PaymentMethod.balance;
    adressState = AdressState.addAddress;
    selectedOffer = OfferScheme(
        country: "",
        id: "",
        internetQuotaInMb: 0,
        voiceQuotaInMinutes: 0,
        smsQuota: 0,
        offerName: "",
        price: 0);
    addressList = [];
    creditCardList = [];
    selectedAddress = BuillingAddressScheme(
      address: '',
      city: '',
      country: '',
      zipCode: '',
      state: '',
    );

    selectedCreditCard = CreditCardScheme(
      cardNumber: '',
      cardHolderName: '',
      cvv: '',
      expiryMonth: '',
      expiryYear: '',
    );
    errors = BuillingAddressScheme(
      address: '',
      city: '',
      state: '',
      zipCode: '',
      country: '',
      isDefault: false,
    );
    errorsHandler = CreditCardScheme(
      cardNumber: '',
      cardHolderName: '',
      expiryMonth: '',
      expiryYear: '',
      cvv: '',
      isDefault: false,
    );
    notifyListeners();
  }

  getBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("balance");
    balance = prefs.getInt('balance') ?? 200;
    if (prefs.getInt('balance') == null) {
      prefs.setInt('balance', 200);
    }
    notifyListeners();
  }

  setPaymentMethod(PaymentMethod method) {
    payementMethod = method;
    notifyListeners();
  }

  setSelectedOffer(OfferScheme offer) {
    selectedOffer = offer;
    getBalance();
    getAdressListFromLocalStorage();
    getCreditCardListFromLocalStorage();
    notifyListeners();
  }

  bool validateEmail() {
    bool isValid = true;
    if (emailController.text.isEmpty) {
      emailError = 'Please enter email';
      isValid = false;
    } else if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text)) {
      emailError = 'Please enter valid email';
      isValid = false;
    }
    if (isValid) {
      emailError = "";
    }
    notifyListeners();
    return isValid;
  }

  addPaypal() {
    if (validateEmail()) {
      CreditCardScheme newCreditCard = CreditCardScheme(
        cardNumber: '',
        cardHolderName: '',
        expiryMonth: '',
        expiryYear: '',
        cvv: '',
        email: emailController.text,
        isDefault: false,
      );
      savePayementMethodListToLocalStorage();
      creditCardList.add(newCreditCard);
      selectedPaymentMethod = newCreditCard;
      payementMethod = PaymentMethod.paypal;
      state = CoverageState.loaded;
      paymenetMethodState = PaymentMethodSatates.showing;
      notifyListeners();
    }
  }

  savePayementMethodListToLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> creditCardListToLocalStorage = [];
    for (var element in creditCardList) {
      creditCardListToLocalStorage.add(element.toJosn());
    }
    prefs.setStringList('creditCardList', creditCardListToLocalStorage);
    paymenetMethodState = PaymentMethodSatates.showing;
    getAdressListFromLocalStorage();
  }

  void saveCreditCard() {
    if (validateAllCreditCardFields()) {
      CreditCardScheme newCreditCard = CreditCardScheme(
        cardNumber: cardNumberController.text,
        cardHolderName: cardHolderNameController.text,
        expiryMonth: expiryMonthController.text,
        expiryYear: expiryYearController.text,
        cvv: cvvController.text,
        isDefault: false,
      );
      selectedPaymentMethod = newCreditCard;
      payementMethod = PaymentMethod.creditCard;
      state = CoverageState.loaded;
      creditCardList.add(newCreditCard);
      savePayementMethodListToLocalStorage();
      paymenetMethodState = PaymentMethodSatates.showing;

      notifyListeners();
    }
  }

  bool validateAllCreditCardFields() {
    DateTime now = DateTime.now();
    bool isValid = true;
    errorsHandler = CreditCardScheme(
      cardNumber: '',
      cardHolderName: '',
      expiryMonth: '',
      expiryYear: '',
      cvv: '',
      isDefault: false,
    );
    notifyListeners();
    if (cardNumberController.text.isEmpty ||
        cardNumberController.text.length < 16) {
      errorsHandler.cardNumber = 'Please enter card number';
      isValid = false;
    } else if (getCreditCardType(cardNumberController.text) ==
            "Invalid Credit Card Number" ||
        getCreditCardType(cardNumberController.text) ==
            "Unknown Credit Card Type") {
      errorsHandler.cardNumber = getCreditCardType(cardNumberController.text);
      isValid = false;
    }
    if (cardHolderNameController.text.isEmpty) {
      errorsHandler.cardHolderName = 'Please enter card holder name';
      isValid = false;
    }
    if (expiryMonthController.text.isEmpty ||
        int.parse(expiryMonthController.text) > 12) {
      errorsHandler.expiryMonth = 'Please enter expiry month';
      isValid = false;
    }
    if (expiryYearController.text.isEmpty ||
        int.parse(expiryYearController.text) < now.year) {
      errorsHandler.expiryYear = 'Please enter expiry year';
      isValid = false;
    }
    if (cvvController.text.isEmpty) {
      errorsHandler.cvv = 'Please enter cvv';
      isValid = false;
    }
    if (expiryYearController.text.isNotEmpty) {
      if (int.parse(expiryYearController.text) == now.year &&
          int.parse(expiryMonthController.text) < now.month) {
        errorsHandler.expiryMonth = 'Please enter valid expiry month';
        isValid = false;
      }
    } else {
      errorsHandler.expiryMonth = 'Please enter valid expiry month';
      isValid = false;
    }
    notifyListeners();
    return isValid;
  }

  void getAdressListFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> addressListFromLocalStorage =
        prefs.getStringList('addressList') ?? [];
    addressList = [];
    for (var element in addressListFromLocalStorage) {
      addressList.add(BuillingAddressScheme.fromJson(element));
    }
    if (addressList.isEmpty) {
      readJson();
      adressState = AdressState.addAddress;
    } else {
      adressState = AdressState.chooseAddress;
    }
    initSelectedAddress();
    notifyListeners();
  }

  toAddAddress() {
    adressState = AdressState.addAddress;
    readJson();
    notifyListeners();
  }

  toChooseAddress() {
    adressState = AdressState.chooseAddress;
    notifyListeners();
  }

  void getCreditCardListFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> creditCardListFromLocalStorage =
        prefs.getStringList('creditCardList') ?? [];
    for (var element in creditCardListFromLocalStorage) {
      creditCardList.add(CreditCardScheme.fromJson(element));
    }
    initSelectedCreditCard();
    state = CoverageState.loaded;
    notifyListeners();
  }

  getActiveOfferFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? activeOfferFromLocalStorage =
        prefs.getStringList('activeOffers');
    if (activeOfferFromLocalStorage != null) {
      for (var element in activeOfferFromLocalStorage) {
        activeOffers.add(OfferScheme.fromJson(element));
      }
    }
    notifyListeners();
  }

  saveActiveOfferToLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> activeOfferToLocalStorage = [];
    for (var element in activeOffers) {
      activeOfferToLocalStorage.add(element.toJson());
    }
    prefs.setStringList('activeOffers', activeOfferToLocalStorage);
  }

  initialize() async {
    state = CoverageState.initial;
    user = await getUser();
    // resetActiveOffersInLocalStorage();
    getActiveOfferFromLocalStorage();
    notifyListeners();
    groupOffersByCountry();
    state = CoverageState.loaded;
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
    if (selectedCity == null) {
      errors.city = 'City is required';
    } else {
      errors.city = '';
    }
    notifyListeners();
  }

  void validateState() {
    if (selectedState == null) {
      errors.state = 'State is required';
    } else {
      errors.state = '';
    }
    notifyListeners();
  }

  toSelectPaymentMethod() {
    state = CoverageState.selectPaymentMehod;
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
    if (selectedCountryField == null) {
      errors.country = 'Country is required';
    } else {
      errors.country = '';
    }
    notifyListeners();
  }

  saveBalanceToLocalStorage() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('balance', balance);
    });
  }

  bool validateAll() {
    validateAddress();
    validateZipCode();
    validateCountry();
    validateCity();
    validateState();
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

  String getPaymentType() {
    if (payementMethod == PaymentMethod.creditCard) {
      return 'Credit Card';
    } else if (payementMethod == PaymentMethod.paypal) {
      return 'PayPal account';
    } else {
      return 'balance';
    }
  }

  resetAllStates() {
    state = CoverageState.initial;
    adressState = AdressState.chooseAddress;
    selectedAddress = BuillingAddressScheme(
      address: '',
      city: '',
      state: '',
      zipCode: '',
      country: '',
    );
    selectedCreditCard = CreditCardScheme(
      cardNumber: '',
      expiryMonth: '',
      expiryYear: '',
      cvv: '',
      cardHolderName: '',
    );
    selectedOffer = OfferScheme(
      country: '',
      price: 0,
      id: '',
      internetQuotaInMb: 0,
      smsQuota: 0,
      offerName: '',
      voiceQuotaInMinutes: 0,
    );

    notifyListeners();
  }

  Future<void> showSuccessDialog(BuildContext context) {
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
                    text: const TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                'Your request has been processed successfully',
                            style: TextStyle(
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

  Future<void> showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: const [
              Center(
                  child: Text(
                'Confirm your purchase',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xff1F84C7),
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
                  text: TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      const TextSpan(text: 'You are about to purchase '),
                      TextSpan(
                          text: selectedOffer.offerName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffF15F22))),
                      const TextSpan(text: ' for your number '),
                      TextSpan(
                          text: user.phoneNumber,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffF15F22))),
                    ],
                  ),
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
                      const TextSpan(
                        text: 'you will benifit  ',
                      ),
                      TextSpan(
                          text:
                              " ${selectedOffer.moreThenOneGb ? selectedOffer.internetQuotaInGb : selectedOffer.internetQuotaInMb} ${selectedOffer.moreThenOneGb ? "Go" : "Mo"} & ${selectedOffer.smsQuota} sms ",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffF15F22))),
                      const TextSpan(text: ' for  '),
                      TextSpan(
                          text: '${selectedOffer.price} DT',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffF15F22))),
                      const TextSpan(text: ' from  your '),
                      TextSpan(
                          text:
                              '${getPaymentType()} ${payementMethod == PaymentMethod.creditCard ? selectedCreditCard.cardNumber : payementMethod == PaymentMethod.paypal ? selectedCreditCard.email : ""}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffF15F22))),
                    ],
                  ),
                ),
                if (payementMethod == PaymentMethod.balance)
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
                        const TextSpan(
                          text: 'your balance will be ',
                        ),
                        TextSpan(
                            text: "${balance - selectedOffer.price} DT",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xffF15F22))),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            left: 25.0,
                            right: 25.0,
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
                            left: 20.0,
                            right: 20.0,
                          ),
                          child: Text('Confirm',
                              style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12)),
                        ),
                        onPressed: () {
                          activeOffers.add(selectedOffer);
                          saveActiveOfferToLocalStorage();

                          if (payementMethod == PaymentMethod.balance) {
                            balance -= selectedOffer.price;

                            saveBalanceToLocalStorage();
                          }
                          resetAllStates();

                          Navigator.of(context).pop();
                          showSuccessDialog(context);
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
}

class OfferScheme {
  String country;
  String offerName;
  String id;
  String operator;
  int internetQuotaInMb;
  int voiceQuotaInMinutes;
  int smsQuota;
  int price;

  double get internetQuotaInGb => internetQuotaInMb / 1024;
  get moreThenOneGb => internetQuotaInGb > 1;
  OfferScheme({
    required this.country,
    required this.id,
    required this.internetQuotaInMb,
    required this.voiceQuotaInMinutes,
    required this.smsQuota,
    required this.offerName,
    required this.price,
    this.operator = "Ooredoo",
  });
  String toJson() {
    return '{"offerName": "$offerName","country": "$country", "id": "$id", "internetQuotaInMb": "$internetQuotaInMb", "voiceQuotaInMinutes": "$voiceQuotaInMinutes", "smsQuota": "$smsQuota", "price": "$price"}';
  }

  String removefirstandlast(String str) {
    return str.substring(1, str.length - 1);
  }

  factory OfferScheme.fromJson(String jsonString) {
    return OfferScheme(
        country: jsonDecode(jsonString)['country'],
        id: jsonDecode(jsonString)['id'],
        internetQuotaInMb:
            int.parse(jsonDecode(jsonString)['internetQuotaInMb']),
        voiceQuotaInMinutes:
            int.parse(jsonDecode(jsonString)['voiceQuotaInMinutes']),
        smsQuota: int.parse(jsonDecode(jsonString)['smsQuota']),
        price: int.parse(jsonDecode(jsonString)['price']),
        offerName: jsonDecode(jsonString)['offerName']);
  }
}
