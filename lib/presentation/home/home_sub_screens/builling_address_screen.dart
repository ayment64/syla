import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syla/controller/authentication_controller/builling_address_controller.dart';
import 'package:syla/shared/Styles/text_styles.dart';
import 'package:syla/shared/widgets/controlled_input_feild.dart';

class BuillingAddressScreen extends StatefulWidget {
  const BuillingAddressScreen({super.key});

  @override
  State<BuillingAddressScreen> createState() => _BuillingAddressScreenState();
}

class _BuillingAddressScreenState extends State<BuillingAddressScreen> {
  TextEditingController addressController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Billing Address"),
        ),
        body: ChangeNotifierProvider.value(
          value: BuillingAddressController(
              addressController: addressController,
              zipCodeController: zipCodeController),
          child: Consumer<BuillingAddressController>(
            builder: (context, value, child) {
              if (value.state == BuillingAddressControllerState.initial) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // your code here that calls setState() or markNeedsBuild()
                  value.initialize();
                });
                return const Center(child: CircularProgressIndicator());
              }
              if (value.state == BuillingAddressControllerState.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (value.state == BuillingAddressControllerState.error) {
                return const Center(child: Text('error'));
              }

              return SingleChildScrollView(
                controller: value.scrollController,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          Text(
                            "Billing Address",
                            style: buillingAddressCardTitle,
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: value.addressList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return BuillingAddressItem(
                          address: value.addressList[index],
                          onTap: () {
                            value.setDefaultIndex(index);
                          },
                        );
                      },
                    ),
                    value.state ==
                            BuillingAddressControllerState.addingBuillingAddress
                        ? Column(
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
                                        value: value.selectedCountry,
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
                                    top: 27.0, left: 24.0, right: 24.0),
                                child: SizedBox(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width, // <-- Your width
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
                                            color: Color(0xffffffff),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                            ],
                          )
                        : Column(children: [
                            const SizedBox(
                              height: 15,
                            ),
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
                                    value.addBuillingAddress();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  child: const Text(
                                    "Add new billing address",
                                    style: TextStyle(
                                        color: Color(0xffffffff),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                          ]),
                  ],
                ),
              );
            },
          ),
        ));
  }
}

class BuillingAddressItem extends StatelessWidget {
  final BuillingAddressScheme address;
  final Function onTap;
  const BuillingAddressItem(
      {super.key, required this.address, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: Checkbox(
                    value: address.isDefault,
                    onChanged: (value) {
                      onTap();
                    },
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.country,
                    style: buillingAddressCardTitle,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${address.address}, ${address.city}",
                    style: buillingAddressCardBody,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("${address.state}, ${address.zipCode}",
                      style: buillingAddressCardBody),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
