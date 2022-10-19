// ignore_for_file: avoid_print, duplicate_ignore

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_techex_app/widgets/appbar_widgets.dart';
import 'package:final_techex_app/widgets/button2.dart';
import 'package:final_techex_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditStore extends StatefulWidget {
  final dynamic data;
  const EditStore({Key? key, required this.data}) : super(key: key);

  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  XFile? imageLogo;
  XFile? imageCover;
  dynamic _pickImageError;
  late String storeName;
  late String phone;
  late String storeLogo;
  late String coverImage;
  bool processing = false;

  final ImagePicker _picker = ImagePicker();
  pickStoreLogo() async {
    try {
      final pickedStoreLogo = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      setState(() {
        imageLogo = pickedStoreLogo;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      // ignore: avoid_print
      print(_pickImageError);
    }
  }

  pickCoverImage() async {
    try {
      final pickedCoverImage = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      setState(() {
        imageCover = pickedCoverImage;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      // ignore: avoid_print
      print(_pickImageError);
    }
  }

  Future uploadStoreLogo() async {
    if (imageLogo != null) {
      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('supplier_image/${widget.data['email']}.jpg');

        await ref.putFile(File(imageLogo!.path));

        storeLogo = await ref.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      storeLogo = widget.data['storelogo'];
    }
  }

  Future uploadCoverImage() async {
    if (imageCover != null) {
      try {
        firebase_storage.Reference ref2 = firebase_storage
            .FirebaseStorage.instance
            .ref('supplier_image/${widget.data['email']}.jpg-cover');

        await ref2.putFile(File(imageCover!.path));

        coverImage = await ref2.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      coverImage = widget.data['coverimage'];
    }
  }

  editStoreData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('suppliers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        'storename': storeName,
        'phone': phone,
        'storelogo': storeLogo,
        'coverimage': coverImage
      });
    }).whenComplete(() => Navigator.pop(context));
  }

  saveChanges() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        processing = true;
      });
      await uploadStoreLogo().whenComplete(() async =>
          await uploadCoverImage().whenComplete(() => editStoreData()));
    } else {
      MyMessageHandler.showSnackBar(scaffoldKey, 'Please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBarBackButton(),
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 31, 129, 117),
          title: const AppBarTitle(title: 'Edit Store'),
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: const Color.fromARGB(255, 31, 129, 117),
                          width: 2.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        const Text(
                          'Store Logo',
                          style: TextStyle(
                              fontSize: 24,
                              color: Color.fromARGB(255, 31, 129, 117),
                              fontWeight: FontWeight.w600),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  NetworkImage(widget.data['storelogo']),
                            ),
                            Column(
                              children: [
                                Button2(
                                    label: 'Change',
                                    onPressed: () {
                                      pickStoreLogo();
                                    },
                                    width: 0.25,
                                    buttonColor: const Color.fromARGB(
                                        255, 31, 129, 117)),
                                const SizedBox(
                                  height: 10,
                                ),
                                imageLogo == null
                                    ? const SizedBox()
                                    : Button2(
                                        label: 'Reset',
                                        onPressed: () {
                                          setState(() {
                                            imageLogo = null;
                                          });
                                        },
                                        width: 0.25,
                                        buttonColor: const Color.fromARGB(
                                            255, 31, 129, 117)),
                              ],
                            ),
                            imageLogo == null
                                ? const SizedBox()
                                : CircleAvatar(
                                    radius: 60,
                                    backgroundImage:
                                        FileImage(File(imageLogo!.path)),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: const Color.fromARGB(255, 31, 129, 117),
                          width: 2.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        const Text(
                          'Cover Image',
                          style: TextStyle(
                              fontSize: 24,
                              color: Color.fromARGB(255, 31, 129, 117),
                              fontWeight: FontWeight.w600),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 60,
                              backgroundImage:
                                  NetworkImage(widget.data['coverimage']),
                            ),
                            Column(
                              children: [
                                Button2(
                                    label: 'Change',
                                    onPressed: () {
                                      pickCoverImage();
                                    },
                                    width: 0.25,
                                    buttonColor: const Color.fromARGB(
                                        255, 31, 129, 117)),
                                const SizedBox(
                                  height: 10,
                                ),
                                imageCover == null
                                    ? const SizedBox()
                                    : Button2(
                                        label: 'Reset',
                                        onPressed: () {
                                          setState(() {
                                            imageCover = null;
                                          });
                                        },
                                        width: 0.25,
                                        buttonColor: const Color.fromARGB(
                                            255, 31, 129, 117)),
                              ],
                            ),
                            imageCover == null
                                ? const SizedBox()
                                : CircleAvatar(
                                    radius: 60,
                                    backgroundImage:
                                        FileImage(File(imageCover!.path)),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Store name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      storeName = value!;
                    },
                    initialValue: widget.data['storename'],
                    decoration: textFormDecoration.copyWith(
                        labelText: 'Store name', hintText: 'Enter Store name')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Phonenumber ';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phone = value!;
                    },
                    initialValue: widget.data['phone'],
                    decoration: textFormDecoration.copyWith(
                        labelText: 'Phone', hintText: 'Enter phone number')),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Button2(
                      label: 'Cancel',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      width: 0.25,
                      buttonColor: Colors.green,
                    ),
                    processing == true
                        ? Button2(
                            label: 'Please wait ..',
                            onPressed: () {
                              null;
                            },
                            width: 0.4,
                            buttonColor: Colors.green)
                        : Button2(
                            label: 'Save Changes',
                            onPressed: () {
                              saveChanges();
                            },
                            width: 0.4,
                            buttonColor: Colors.green)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
    labelText: 'Price',
    hintText: '\$',
    labelStyle: const TextStyle(
        color: Color.fromARGB(255, 6, 9, 9), fontWeight: FontWeight.bold),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
    enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 31, 129, 117), width: 2),
        borderRadius: BorderRadius.circular(20)),
    focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 31, 129, 117), width: 2),
        borderRadius: BorderRadius.circular(20)));
