import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syla/controller/authentication_controller/payment_method_controller.dart';
import 'package:syla/shared/contents/text_values.dart';
import 'package:syla/shared/widgets/controlled_input_feild.dart';

class PayementMethodScreen extends StatelessWidget {
  const PayementMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
      ),
      body: ChangeNotifierProvider.value(
        value: PayementMethodController(),
        child: Consumer<PayementMethodController>(
          builder: (context, value, child) {
            if (value.state == PayementMethodControllerState.initial) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // your code here that calls setState() or markNeedsBuild()
                value.initialize();
              });
              return const Center(child: CircularProgressIndicator());
            }
            if (value.state == PayementMethodControllerState.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (value.state == PayementMethodControllerState.error) {
              return const Center(child: Text('error'));
            }

            return SingleChildScrollView(
              controller: value.scrollController,
              child: Column(children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: value.creditCardList.length,
                  padding: const EdgeInsets.all(6.0),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (value.creditCardList[index].cardNumber == "") {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              border: const Border(
                                // borderRadius: BorderRadius.all(Radius.circular(5)),
                                bottom: BorderSide(
                                    width: 3.5, color: Color(0xffE75EA0)),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Paypal",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      IconButton(
                                        onPressed: () {
                                          value.deletePayementMethod(
                                              context, index);
                                        },
                                        icon: const Icon(Icons.delete_outline,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "Account:  ${value.creditCardList[index].email}",
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400)),
                                      Image.asset(
                                        "assets/images/paypal.png",
                                        width: 50,
                                        height: 50,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            border: const Border(
                              // borderRadius: BorderRadius.all(Radius.circular(5)),
                              bottom: BorderSide(
                                  width: 3.5, color: Color(0xffE75EA0)),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        value.getCreditCardType(value
                                            .creditCardList[index].cardNumber),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    IconButton(
                                      onPressed: () {
                                        value.deletePayementMethod(
                                            context, index);
                                      },
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        "Card number: ${getCardNumber(value.creditCardList[index].cardNumber)}",
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Text(
                                      "Holder name: ${value.creditCardList[index].cardHolderName}",
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400)),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "Expires in:  ${value.creditCardList[index].expiryMonth}/${value.creditCardList[index].expiryYear}",
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                    value.getCreditCardType(value
                                                .creditCardList[index]
                                                .cardNumber) ==
                                            "Visa"
                                        ? Image.asset(
                                            "assets/images/visa.png",
                                            width: 50,
                                            height: 50,
                                          )
                                        : Image.asset(
                                            "assets/images/mastercard.png",
                                            width: 50,
                                            height: 50,
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                value.state == PayementMethodControllerState.addPayementMethod
                    ? Column(
                        children: [
                          PaymentMethodTypeWidget(
                            value: value,
                            text: "Credit Card",
                            payementMethodType: PayementMethodType.creditCard,
                            prefix: const Padding(
                              padding: EdgeInsets.only(left: 8.0, right: 15.0),
                              child: Icon(Icons.credit_card_outlined),
                            ),
                          ),
                          PaymentMethodTypeWidget(
                            value: value,
                            text: "Paypal",
                            payementMethodType: PayementMethodType.paypal,
                            prefix: Image.asset("assets/images/paypal.png",
                                width: 50, height: 50),
                          ),
                          value.payementMethodType == PayementMethodType.paypal
                              ? PaymentMethodPaypalTab(
                                  value: value,
                                )
                              : PaymentMethodCreditCardTab(value: value),
                        ],
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 27.0, left: 24.0, right: 24.0),
                            child: SizedBox(
                                width: MediaQuery.of(context)
                                    .size
                                    .width, // <-- Your width
                                height: 48, // <-- Your height
                                child: ElevatedButton(
                                  onPressed: () {
                                    value.addPayementMethod();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  child: const Text("Add new Payment Method",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xffffffff))),
                                )),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
              ]),
            );
          },
        ),
      ),
    );
  }
}

class PaymentMethodPaypalTab extends StatelessWidget {
  final dynamic value;
  const PaymentMethodPaypalTab({
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 28.0),
          child: ControlledInputField(
              setValue: value.emailController,
              placeHolder: emailPlaceHolder,
              errorText: value.emailError),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 27.0, left: 24.0, right: 24.0),
          child: SizedBox(
              width: MediaQuery.of(context).size.width, // <-- Your width
              height: 48, // <-- Your height
              child: ElevatedButton(
                onPressed: () {
                  if (value.validateEmail()) {
                    value.addPaypal();
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text("Save",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffffffff))),
              )),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}

class PaymentMethodCreditCardTab extends StatelessWidget {
  final dynamic value;
  const PaymentMethodCreditCardTab({
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 28.0),
          child: ControlledInputField(
              setValue: value.cardNumberController,
              textInputType: TextInputType.number,
              placeHolder: "Card Number",
              errorText: value.errorsHandler.cardNumber),
        ),
        const SizedBox(
          height: 10,
        ),
        ControlledInputField(
            textInputType: TextInputType.number,
            setValue: value.cvvController,
            placeHolder: "CVV",
            errorText: value.errorsHandler.cvv),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ControlledInputField(
                setValue: value.expiryMonthController,
                placeHolder: "Month",
                textInputType: TextInputType.number,
                padding: const EdgeInsets.only(left: 24.0, right: 6.0),
                errorText: value.errorsHandler.expiryMonth,
                widthRatio: 0.5,
              ),
              ControlledInputField(
                setValue: value.expiryYearController,
                placeHolder: "Year",
                textInputType: TextInputType.number,
                errorPadding: const EdgeInsets.only(left: 18.0, right: 24.0),
                padding: const EdgeInsets.only(right: 24.0, left: 6.0),
                errorText: value.errorsHandler.expiryYear,
                widthRatio: 0.5,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ControlledInputField(
            setValue: value.cardHolderNameController,
            placeHolder: "Card Holder Name",
            errorText: value.errorsHandler.cardHolderName),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 27.0, left: 24.0, right: 24.0),
          child: SizedBox(
              width: MediaQuery.of(context).size.width, // <-- Your width
              height: 48, // <-- Your height
              child: ElevatedButton(
                onPressed: () {
                  value.saveCreditCard();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text("Save",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffffffff))),
              )),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}

class PaymentMethodTypeWidget extends StatelessWidget {
  final dynamic value;
  final PayementMethodType payementMethodType;
  final String text;
  final Widget prefix;
  const PaymentMethodTypeWidget({
    required this.payementMethodType,
    required this.value,
    required this.text,
    required this.prefix,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              value.changePayementMethodType(payementMethodType);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    prefix,
                    Text(
                      text,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Radio<PayementMethodType>(
                    value: payementMethodType,
                    groupValue: value.payementMethodType,
                    onChanged: (PayementMethodType? type) {
                      value.changePayementMethodType(type);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
