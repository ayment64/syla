import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syla/controller/authentication_controller/coverage_controller.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:syla/controller/authentication_controller/payment_method_controller.dart';
import 'package:syla/presentation/home/home_sub_screens/payement_method_screen.dart';
import 'package:syla/shared/Styles/text_styles.dart';
import 'package:syla/shared/widgets/controlled_input_feild.dart';

class CouvertureScreen extends StatefulWidget {
  const CouvertureScreen({super.key});

  @override
  State<CouvertureScreen> createState() => _CouvertureScreenState();
}

class _CouvertureScreenState extends State<CouvertureScreen> {
  TextEditingController addressController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController expiryMonthController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryYearController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: CoverageController(
        addressController: addressController,
        zipCodeController: zipCodeController,
        cardHolderNameController: cardHolderNameController,
        expiryMonthController: expiryMonthController,
        cardNumberController: cardNumberController,
        expiryYearController: expiryYearController,
        cvvController: cvvController,
        emailController: emailController,
      ),
      child: Consumer<CoverageController>(
        builder: (context, value, child) {
          if (value.state == CoverageState.initial) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              value.initialize();
            });
          }
          if (value.state == CoverageState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (value.state == CoverageState.selectPaymentMehod) {
            return Scaffold(
                appBar: AppBar(
                    title: const Text("Coverage"),
                    centerTitle: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        value.setCoverageState(CoverageState.loaded);
                        // value.resetSelectedOffer();
                      },
                    )),
                body: SingleChildScrollView(
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
                            child: InkWell(
                              onTap: () {
                                value.chosePaymentMethod(
                                    value.creditCardList[index],
                                    PaymentMethod.paypal);
                              },
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: const [
                                            Text("Paypal",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                                                    fontWeight:
                                                        FontWeight.w400)),
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
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              value.chosePaymentMethod(
                                  value.creditCardList[index],
                                  PaymentMethod.creditCard);
                            },
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              getCreditCardType(value
                                                  .creditCardList[index]
                                                  .cardNumber),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
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
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
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
                                          getCreditCardType(value
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
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    value.paymenetMethodState == PaymentMethodSatates.adding
                        ? Column(
                            children: [
                              PaymentMethodTypeWidget(
                                value: value,
                                text: "Credit Card",
                                payementMethodType:
                                    PayementMethodType.creditCard,
                                prefix: const Padding(
                                  padding:
                                      EdgeInsets.only(left: 8.0, right: 15.0),
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
                              value.payementMethodType ==
                                      PayementMethodType.paypal
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
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      child: const Text(
                                          "Add new Payment Method",
                                          textAlign: TextAlign.center,
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
                ));
          }
          if (value.selectedOffer.offerName != "") {
            return Scaffold(
              appBar: AppBar(
                  title: const Text("Coverage"),
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      value.resetSelectedOffer();
                    },
                  )),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Selected Offer",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff010101)),
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(
                            color: Color(0xffD9D9D9),
                            thickness: 1,
                          ),
                        )),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/bigbox.png",
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 150,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                value.selectedOffer.offerName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff010101),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                    "Details: ${value.selectedOffer.moreThenOneGb ? value.selectedOffer.internetQuotaInGb : value.selectedOffer.internetQuotaInMb} ${value.selectedOffer.moreThenOneGb ? "Go" : "Mo"} & ${value.selectedOffer.smsQuota} sms",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff4369AE))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                    "Price: ${value.selectedOffer.price} DT",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff81888E))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                    "Operator: ${value.selectedOffer.operator} ",
                                    overflow: TextOverflow.clip,
                                    maxLines: 3,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff81888E))),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Billing Address",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff010101)),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Divider(
                              color: Color(0xffD9D9D9),
                              thickness: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    value.adressState == AdressState.chooseAddress
                        ? Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: const Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(18, 0, 18, 0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      icon: Transform.rotate(
                                          angle: 1.5708,
                                          child: const Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                          )),

                                      dropdownColor: Colors.white,
                                      value: value.selectedAddress,
                                      items: value.addressList
                                          .map((e) => DropdownMenuItem(
                                                value: e,
                                                child: Text(
                                                    "${e.country}, ${e.state}"),
                                              ))
                                          .toList(),
                                      onChanged: (temp) {
                                        if (temp != null) {
                                          value.setSelectedAdress(temp);
                                        }
                                      },
                                      // style: Theme.of(context).textTheme.title,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 27.0, left: 27, right: 27),
                                child: SizedBox(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width, // <-- Your width
                                    height: 48, // <-- Your height
                                    child: ElevatedButton(
                                      onPressed: () {
                                        value.toAddAddress();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      child:
                                          const Text("Add new billing address"),
                                    )),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              ControlledInputField(
                                errorText: value.errors.address,
                                placeHolder: 'Address',
                                setValue: value.addressController,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 24.0, right: 24.0),
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color:
                                          const Color.fromARGB(255, 69, 69, 69),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(18, 0, 18, 0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        icon: Transform.rotate(
                                            angle: 1.5708,
                                            child: const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16,
                                            )),
                                        hint: const Text("Country"),
                                        dropdownColor: Colors.white,
                                        value: value.selectedCountryField,
                                        items: value.countries
                                            .map((e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e),
                                                ))
                                            .toList(),
                                        onChanged: (temp) {
                                          if (temp != null) {
                                            value.setCountry(temp);
                                            value.validateCountry();
                                          }
                                        },
                                        //  style: Theme.of(context).textTheme.title,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 24, right: 24),
                                child: Row(
                                  children: [
                                    value.errors.country.isNotEmpty
                                        ? Flexible(
                                            child: Text(value.errors.country,
                                                style: errorTextStyle))
                                        : Container(),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 24.0, right: 24.0),
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color:
                                          const Color.fromARGB(255, 69, 69, 69),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(18, 0, 18, 0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        icon: Transform.rotate(
                                            angle: 1.5708,
                                            child: const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16,
                                            )),
                                        hint: const Text("State"),
                                        dropdownColor: Colors.white,
                                        value: value.selectedState,
                                        items: value.states
                                            .map((e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e),
                                                ))
                                            .toList(),
                                        onChanged: (temp) {
                                          if (temp != null) {
                                            value.setGeoState(temp);
                                            value.validateState();
                                          }
                                        },
                                        //  style: Theme.of(context).textTheme.title,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 24, right: 24),
                                child: Row(
                                  children: [
                                    value.errors.state.isNotEmpty
                                        ? Flexible(
                                            child: Text(value.errors.state,
                                                style: errorTextStyle))
                                        : Container(),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 24.0, right: 6.0),
                                            child: Container(
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 69, 69, 69),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        18, 0, 18, 0),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    itemHeight: null,
                                                    icon: Transform.rotate(
                                                        angle: 1.5708,
                                                        child: const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          size: 16,
                                                        )),
                                                    hint: const Text("City"),
                                                    dropdownColor: Colors.white,
                                                    value: value.selectedCity,
                                                    items: value.cities
                                                        .map((e) =>
                                                            DropdownMenuItem(
                                                              value: e,
                                                              child: Text(e),
                                                            ))
                                                        .toList(),
                                                    onChanged: (temp) {
                                                      if (temp != null) {
                                                        value.setCity(temp);
                                                        value.validateCity();
                                                      }
                                                    },
                                                    //  style: Theme.of(context).textTheme.title,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 24, right: 6),
                                            child: Row(
                                              children: [
                                                value.errors.city.isNotEmpty
                                                    ? Text(value.errors.city,
                                                        style: errorTextStyle)
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                        ],
                                      ),
                                    ),
                                    ControlledInputField(
                                      errorText: value.errors.zipCode,
                                      placeHolder: 'Zip Code',
                                      setValue: value.zipCodeController,
                                      errorPadding: const EdgeInsets.only(
                                          left: 18.0, right: 24.0),
                                      padding: const EdgeInsets.only(
                                          right: 24.0, left: 6.0),
                                      widthRatio: 0.5,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 27.0, left: 27, right: 27),
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 48, // <-- Your height
                                    child: ElevatedButton(
                                      onPressed: () {
                                        value.saveAddress();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      child: const Text(
                                        "Save Address",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffffffff)),
                                      ),
                                    )),
                              ),
                              value.addressList.isNotEmpty
                                  ? TextButton(
                                      onPressed: () {
                                        value.toChooseAddress();
                                      },
                                      child: const Text(
                                        "Choose from my saved addresses",
                                      ))
                                  : Container(),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Payment Method",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff010101)),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Divider(
                              color: Color(0xffD9D9D9),
                              thickness: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(
                                0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset("assets/images/logo-big.png",
                                  width: 50, height: 50),
                            ),
                            const Text("My Balance",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff010101))),
                            Radio<PaymentMethod>(
                                value: PaymentMethod.balance,
                                groupValue: value.payementMethod,
                                onChanged: (temp) {
                                  if (temp != null) {
                                    value.setPaymentMethod(temp);
                                  }
                                }),
                          ],
                        ),
                        value.balance < value.selectedOffer.price
                            ? Column(
                                children: [
                                  const Divider(
                                    color: Color(0xffD9D9D9),
                                    thickness: 1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                        "Payment via mobile balance. Make sure you have enough funds or top up before paying. Check your balance before purchase.",
                                        style: errorTextStyle),
                                  ),
                                ],
                              )
                            : Container(),
                      ]),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    value.payementMethod == PaymentMethod.creditCard
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: const Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              getCreditCardType(value
                                                  .selectedPaymentMethod
                                                  .cardNumber),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          Radio<PaymentMethod>(
                                              value: PaymentMethod.creditCard,
                                              groupValue: value.payementMethod,
                                              onChanged: (temp) {
                                                if (temp != null) {
                                                  value.setPaymentMethod(temp);
                                                }
                                              }),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                              "Card number: ${getCardNumber(value.selectedPaymentMethod.cardNumber)}",
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400)),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Text(
                                            "Holder name: ${value.selectedPaymentMethod.cardHolderName}",
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
                                              "Expires in:  ${value.selectedPaymentMethod.expiryMonth}/${value.selectedPaymentMethod.expiryYear}",
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400)),
                                          getCreditCardType(value
                                                      .selectedPaymentMethod
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
                          )
                        : Container(),
                    value.payementMethod == PaymentMethod.paypal
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: const Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          Radio<PaymentMethod>(
                                              value: PaymentMethod.paypal,
                                              groupValue: value.payementMethod,
                                              onChanged: (temp) {
                                                if (temp != null) {
                                                  value.setPaymentMethod(temp);
                                                }
                                              }),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "Account:  ${value.selectedPaymentMethod.email}",
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
                          )
                        : Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                        onPressed: () {
                          value.toSelectPaymentMethod();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Choose another payment method",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        )),
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
                              if (value.payementMethod ==
                                      PaymentMethod.balance &&
                                  value.balance < value.selectedOffer.price) {
                                return;
                              }
                              value.showMyDialog(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: const Text(
                              "Checkout",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffffffff)),
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            );
          }
          if (value.selectedCountry != "") {
            return Scaffold(
              appBar: AppBar(
                  title: const Text("Coverage"),
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      value.resetSelectedCountry();
                    },
                  )),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(value.selectedCountry,
                        style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff384454))),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Image.asset(
                        "assets/images/${value.selectedCountry.toLowerCase()}-150x150.png",
                        width: 80,
                        height: 80,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    for (int i = 0; i < value.selectedCountryOffers.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/offer.png",
                                    width: 150,
                                    height: 100,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          value.selectedCountryOffers[i]
                                              .offerName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff010101),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Text(
                                            "Details: ${value.selectedCountryOffers[i].moreThenOneGb ? value.selectedCountryOffers[i].internetQuotaInGb : value.selectedCountryOffers[i].internetQuotaInMb} ${value.selectedCountryOffers[i].moreThenOneGb ? "Go" : "Mo"} & ${value.selectedCountryOffers[i].smsQuota} sms",
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff4369AE))),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                              "Price: ${value.selectedCountryOffers[i].price} DT",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff81888E))),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                            "Operator: ${value.selectedCountryOffers[i].operator} ",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff81888E))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                            onTap: () {
                                              value.setSelectedOffer(value
                                                  .selectedCountryOffers[i]);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color:
                                                      const Color(0xff4369AE),
                                                  width: 1,
                                                ),
                                                color: const Color(0xff4369AE),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    14.0, 4.0, 14.0, 4.0),
                                                child: Text(
                                                  "Buy Now",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xffffffff)),
                                                ),
                                              ),
                                            )),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }
          return Scaffold(
              appBar: AppBar(
                title: const Text("Coverage"),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var element in value.offersByCountry.entries)
                      CountryOffersItem(
                        element: element,
                        value: value,
                      )
                  ],
                ),
              ));
        },
      ),
    );
  }
}

class CountryOffersItem extends StatefulWidget {
  const CountryOffersItem({
    super.key,
    required this.element,
    required this.value,
  });
  final CoverageController value;
  final MapEntry<String, List<OfferScheme>> element;

  @override
  State<CountryOffersItem> createState() => _CountryOffersItemState();
}

class _CountryOffersItemState extends State<CountryOffersItem> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    expanded = !expanded;
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/${widget.element.key.toLowerCase()}.png",
                      width: 100,
                      height: 80,
                    ),
                    Text(
                      widget.element.key,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff81888E)),
                    ),
                    // const Spacer(),
                    const Text(
                      ": 3g, 4g",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffAEAEAE)),
                    ),
                    const Spacer(),
                    Transform.rotate(
                      angle: !expanded ? 3.14 / 2 : -3.14 / 2,
                      child: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          color: const Color(0xff81888E),
                          iconSize: 18,
                          onPressed: () {
                            setState(() {
                              expanded = !expanded;
                            });
                          }),
                    )
                  ],
                ),
              ),
              expanded
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          const Divider(
                            color: Color(0xffAEAEAE),
                            thickness: 1,
                          ),
                          for (int i = 0; i < 3; i++)
                            Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/offer.png",
                                      width: 200,
                                      height: 100,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            widget.element.value[i].offerName,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff010101),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            child: Text(
                                                "${widget.element.value[i].internetQuotaInMb} Mo & ${widget.element.value[i].smsQuota} sms",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff4369AE))),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                              "${widget.element.value[i].price} DT",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff81888E))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                              onTap: () {
                                                widget.value.setSelectedOffer(
                                                    widget.element.value[i]);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xff4369AE),
                                                    width: 1,
                                                  ),
                                                  color:
                                                      const Color(0xff4369AE),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      14.0, 4.0, 14.0, 4.0),
                                                  child: Text(
                                                    "Buy Now",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xffffffff)),
                                                  ),
                                                ),
                                              )),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                i < 2
                                    ? const Padding(
                                        padding: EdgeInsets.only(
                                            left: 18.0, right: 18.0),
                                        child: DottedLine(
                                          direction: Axis.horizontal,
                                          dashColor: Color(0xff4369AE),
                                          lineThickness: 1.0,
                                          dashLength: 8.0,
                                          dashGapLength: 8.0,
                                        ),
                                      )
                                    : const SizedBox(
                                        height: 20,
                                      ),
                              ],
                            ),
                          widget.element.value.length > 3
                              ? InkWell(
                                  onTap: () {
                                    widget.value
                                        .setSelectedCountry(widget.element.key);
                                  },
                                  child: const Text("View more",
                                      style: TextStyle(
                                        color: Color(0xff939393),
                                        fontSize: 18,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                      )),
                                )
                              : Container(),
                          const SizedBox(
                            height: 20,
                          )
                        ])
                  : Container(),
            ],
          )),
    );
  }
}
