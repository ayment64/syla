import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PayementMethodControllerState {
  initial,
  loading,
  loaded,
  addPayementMethod,
  error,
}

enum PayementMethodType { creditCard, paypal }

enum CreditCards {
  visa,
  masterCard,
  americanExpress,
  discover,
  dinersClub,
  jcb,
  unionPay,
  maestro,
  mir,
  elo,
  hiper,
}

class PayementMethodController extends ChangeNotifier {
  PayementMethodControllerState state = PayementMethodControllerState.initial;
  PayementMethodType payementMethodType = PayementMethodType.creditCard;
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController expiryMonthController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryYearController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String emailError = '';
  int selecteIndex = 0;
  CreditCardScheme errorsHandler = CreditCardScheme(
    cardNumber: '',
    cardHolderName: '',
    expiryMonth: '',
    expiryYear: '',
    cvv: '',
    isDefault: false,
  );
  ScrollController scrollController = ScrollController();
  List<CreditCardScheme> creditCardList = [];
  int isDefault = 0;

  void initialize() {
    state = PayementMethodControllerState.loading;

    getCreditCardListFromLocalStorage();
  }

  // replace the last 6 digits of the card number with asterisks

  void getCreditCardListFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> creditCardListFromLocalStorage =
        prefs.getStringList('creditCardList') ?? [];
    for (var element in creditCardListFromLocalStorage) {
      creditCardList.add(CreditCardScheme.fromJson(element));
    }
    initDefaultIndex();
    state = PayementMethodControllerState.loaded;
    notifyListeners();
  }

  initDefaultIndex() {
    for (var element in creditCardList) {
      if (element.isDefault) {
        isDefault = creditCardList.indexOf(element);
      }
    }
    notifyListeners();
  }

  setDefaultIndex(int index) {
    isDefault = index;
    for (var element in creditCardList) {
      if (element.isDefault) {
        element.isDefault = false;
      }
    }
    creditCardList[index].isDefault = true;

    notifyListeners();
  }

  savePayementMethodListToLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> creditCardListToLocalStorage = [];
    for (var element in creditCardList) {
      creditCardListToLocalStorage.add(element.toJosn());
    }
    prefs.setStringList('creditCardList', creditCardListToLocalStorage);
    state = PayementMethodControllerState.loaded;
  }

  deletePayementMethod(BuildContext context, int index) {
    selecteIndex = index;
    _showMyDialog(context);
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: const [
              Center(
                  child: Text(
                'Delete payement method',
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
              children: <Widget>[
                creditCardList[selecteIndex].cardNumber != ""
                    ? const Text(
                        'Are you sure you want to delete this credit card ?',
                        textAlign: TextAlign.center,
                      )
                    : const Text(
                        'Are you sure you want to delete this paypal account?',
                        textAlign: TextAlign.center,
                      ),
                const SizedBox(
                  height: 30,
                ),
                creditCardList[selecteIndex].cardNumber != ""
                    ? Text(
                        getCardNumber(creditCardList[selecteIndex].cardNumber),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      )
                    : Text(
                        creditCardList[selecteIndex].email ?? "",
                        style: const TextStyle(fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border:
                        Border.all(color: const Color(0xff1F84C7), width: 2),
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
                    border:
                        Border.all(color: const Color(0xff1F84C7), width: 2),
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
                      // Navigator.of(context).pop();
                      creditCardList.removeAt(selecteIndex);
                      savePayementMethodListToLocalStorage();
                      state = PayementMethodControllerState.loaded;
                      notifyListeners();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10)
          ],
        );
      },
    );
  }

  void saveCreditCard() {
    if (validateAll()) {
      CreditCardScheme newCreditCard = CreditCardScheme(
        cardNumber: cardNumberController.text,
        cardHolderName: cardHolderNameController.text,
        expiryMonth: expiryMonthController.text,
        expiryYear: expiryYearController.text,
        cvv: cvvController.text,
        isDefault: false,
      );
      creditCardList.add(newCreditCard);
      savePayementMethodListToLocalStorage();
      state = PayementMethodControllerState.loaded;

      notifyListeners();
    }
  }

  bool validateAll() {
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
    if (expiryMonthController.text.isNotEmpty &&
        expiryYearController.text.isNotEmpty) {
      if (int.parse(expiryYearController.text) == now.year &&
          int.parse(expiryMonthController.text) < now.month) {
        errorsHandler.expiryMonth = 'Please enter valid expiry month';
        isValid = false;
      }
    }
    if (cvvController.text.isEmpty) {
      errorsHandler.cvv = 'Please enter cvv';
      isValid = false;
    }
    notifyListeners();
    return isValid;
  }

  void addPayementMethod() {
    state = PayementMethodControllerState.addPayementMethod;
    notifyListeners();
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 490,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
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

  changePayementMethodType(PayementMethodType? type) {
    if (type == null) return;
    payementMethodType = type;
    notifyListeners();
  }

  String getCreditCardType(String cardNumber) {
    // Validate the credit card number using the Luhn algorithm
    if (!isValidCreditCardNumber(cardNumber)) {
      return "Invalid Credit Card Number";
    }
    if (RegExp("^4").hasMatch(cardNumber)) {
      return "Visa";
    } else if (RegExp("^(51|52|53|54|55)").hasMatch(cardNumber)) {
      return "Mastercard";
    } else {
      return "Unknown Credit Card Type";
    }
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
      creditCardList.add(newCreditCard);
      savePayementMethodListToLocalStorage();
      state = PayementMethodControllerState.loaded;

      notifyListeners();
    }
  }
}

class CreditCardScheme {
  String cardNumber;
  String cardHolderName;
  String expiryMonth;
  String expiryYear;
  String cvv;
  String? email;
  bool isDefault;

  CreditCardScheme({
    required this.cardNumber,
    required this.cardHolderName,
    required this.cvv,
    this.isDefault = false,
    required this.expiryMonth,
    required this.expiryYear,
    this.email = '',
  });

  String toJosn() {
    return '{"cardNumber": "$cardNumber","email": "$email", "cardHolderName": "$cardHolderName", "expiryMonth": "$expiryMonth", "expiryYear": "$expiryYear", "cvv": "$cvv", "isDefault": "$isDefault"}';
  }

  factory CreditCardScheme.fromJson(String json) {
    return CreditCardScheme(
      cardNumber: jsonDecode(json)["cardNumber"],
      cardHolderName: jsonDecode(json)["cardHolderName"],
      expiryMonth: jsonDecode(json)["expiryMonth"],
      expiryYear: jsonDecode(json)["expiryYear"],
      email: jsonDecode(json)["email"],
      cvv: jsonDecode(json)["cvv"],
      isDefault: jsonDecode(json)["isDefault"] == "true",
    );
  }
}

String getCreditCardType(String cardNumber) {
  // Validate the credit card number using the Luhn algorithm
  if (!isValidCreditCardNumber(cardNumber)) {
    return "Invalid Credit Card Number";
  }
  if (RegExp("^4").hasMatch(cardNumber)) {
    return "Visa";
  } else if (RegExp("^(51|52|53|54|55)").hasMatch(cardNumber)) {
    return "Mastercard";
  } else {
    return "Unknown Credit Card Type";
  }
}

bool isValidCreditCardNumber(String cardNumber) {
  // Implement the Luhn algorithm to validate the credit card number
  int sum = 0;
  bool isEven = false;
  for (int i = cardNumber.length - 1; i >= 0; i--) {
    int digit = int.parse(cardNumber[i]);
    if (isEven) {
      digit *= 2;
      if (digit > 9) {
        digit -= 9;
      }
    }
    sum += digit;
    isEven = !isEven;
  }
  return sum % 10 == 0;
}

String getCardNumber(String cardNumber) {
  String lastFourDigits = cardNumber.substring(cardNumber.length - 4);
  String firstTwoDigits = cardNumber.substring(0, 2);
  String asterisks = '';
  for (var i = 0; i < cardNumber.length - 6; i++) {
    asterisks += '*';
  }
  return firstTwoDigits + asterisks + lastFourDigits;
}
