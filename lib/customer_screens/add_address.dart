import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_techex_app/widgets/appbar_widgets.dart';
import 'package:final_techex_app/widgets/button2.dart';
import 'package:final_techex_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:uuid/uuid.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late String firstName;
  late String lastName;
  late String phone;
  String countryValue = 'Çhoose Country';
  String stateValue = 'Choose State';
  String cityValue = 'Çhoose City';
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 31, 129, 117),
          leading: const AppBarBackButton(),
          title: const AppBarTitle(
            title: 'Add Address',
          ),
        ),
        body: SafeArea(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.60,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              firstName = value!;
                            },
                            decoration: textFormDecoration.copyWith(
                              labelText: 'First Name',
                              hintText: 'Enter your first name',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.60,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              lastName = value!;
                            },
                            decoration: textFormDecoration.copyWith(
                              labelText: 'Last Name',
                              hintText: 'Enter your last name',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.60,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              phone = value!;
                            },
                            decoration: textFormDecoration.copyWith(
                              labelText: 'Phone Number',
                              hintText: 'Enter your phone number',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SelectState(
                  // style: TextStyle(color: Colors.red),
                  onCountryChanged: (value) {
                    setState(() {
                      countryValue = value;
                    });
                  },
                  onStateChanged: (value) {
                    setState(() {
                      stateValue = value;
                    });
                  },
                  onCityChanged: (value) {
                    setState(() {
                      cityValue = value;
                    });
                  },
                ),
                Center(
                  child: Button2(
                      label: 'Add New Address',
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          if (countryValue != 'Choose Country' &&
                              stateValue != 'Choose State' &&
                              cityValue != 'Choose City') {
                            formKey.currentState!.save();
                            CollectionReference addressRef = FirebaseFirestore
                                .instance
                                .collection('customers')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('address');
                            var addressId = const Uuid().v4();
                            await addressRef.doc(addressId).set({
                              'addressid': addressId,
                              'firstname': firstName,
                              'lastname': lastName,
                              'phone': phone,
                              'country': countryValue,
                              'state': stateValue,
                              'city': cityValue,
                              'default': true,
                            }).whenComplete(() => Navigator.pop(context));
                          } else {
                            MyMessageHandler.showSnackBar(
                                _scaffoldKey, 'Please add your location');
                          }
                        } else {
                          MyMessageHandler.showSnackBar(
                              _scaffoldKey, 'Please fill all fields');
                        }
                      },
                      width: 0.8,
                      buttonColor: Colors.green.shade400),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: 'Full Name',
  hintText: 'Enter your full name',
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.green, width: 2),
      borderRadius: BorderRadius.circular(25)),
  focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 2),
      borderRadius: BorderRadius.circular(25)),
);
