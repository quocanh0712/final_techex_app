// ignore_for_file: avoid_print, duplicate_ignore

// ignore: avoid_web_libraries_in_flutter

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_techex_app/utilities/category_list.dart';
import 'package:final_techex_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({Key? key}) : super(key: key);

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late double price;
  late int quantity;
  late String productName;
  late String productDesc;
  late String productId;
  String mainCategoryValue = 'Select Category';
  String subCategoryValue = 'SubCategory';
  bool processing = false;

  List<String> subCategoryList = [];

  final ImagePicker _picker = ImagePicker();

  List<XFile>? imagesFileList = [];
  List<String> imagesUrlList = [];
  dynamic _pickImageError;

  void uploadProductImages() async {
    try {
      final uploadedImages = await _picker.pickMultiImage(
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      setState(() {
        imagesFileList = uploadedImages!;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      print(_pickImageError);
    }
  }

  Widget previewsImages() {
    if (imagesFileList!.isNotEmpty) {
      return ListView.builder(
          itemCount: imagesFileList!.length,
          itemBuilder: (context, index) {
            return Image.file(File(imagesFileList![index].path));
          });
    } else {
      return const Center(
        child: Text('No photos selected !'),
      );
    }
  }

  void selectMainCategory(String? value) {
    if (value == 'Select Category') {
      subCategoryList = [];
    } else if (value == 'Phone & Accessories') {
      subCategoryList = phoneandaccessories;
    } else if (value == 'Electronic device') {
      subCategoryList = electronicdevice;
    } else if (value == 'Computer & Laptop') {
      subCategoryList = computerandlaptop;
    } else if (value == 'Camera & Camcorder') {
      subCategoryList = cameraandcamcorder;
    } else if (value == 'Smart watch') {
      subCategoryList = smartwatch;
    } else if (value == 'Household appliances') {
      subCategoryList = householdappliances;
    }
    print(value);
    setState(() {
      mainCategoryValue = value!;
      subCategoryValue = 'SubCategory';
    });
  }

  Future<void> uploadImages() async {
    if (mainCategoryValue != 'Select Category' &&
        subCategoryValue != 'SubCategory') {
      if (_formKey.currentState!.validate()) {
        // ignore: avoid_print
        _formKey.currentState!.save();

        if (imagesFileList!.isNotEmpty) {
          setState(() {
            processing = true;
          });
          try {
            for (var image in imagesFileList!) {
              firebase_storage.Reference ref = firebase_storage
                  .FirebaseStorage.instance
                  .ref('products/${path.basename(image.path)}');

              await ref.putFile(File(image.path)).whenComplete(() async {
                await ref.getDownloadURL().then((value) {
                  imagesUrlList.add(value);
                });
              });
            }
          } catch (e) {
            print(e);
          }

          _formKey.currentState!.reset();
        } else {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'Please choose product images !');
        }
      } else {
        MyMessageHandler.showSnackBar(_scaffoldKey, 'Please fill all fields');
      }
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'Please select categories');
    }
  }

  void uploadData() async {
    if (imagesUrlList.isNotEmpty) {
      CollectionReference productRef =
          FirebaseFirestore.instance.collection('products');

      productId = const Uuid().v4();

      await productRef.doc(productId).set({
        'productId': productId,
        'maincategory': mainCategoryValue,
        'subcategory': subCategoryValue,
        'price': price,
        'instock': quantity,
        'productname': productName,
        'productdesc': productDesc,
        'sid': FirebaseAuth.instance.currentUser!.uid,
        'productimages': imagesUrlList,
        'discount': 0, // add discount later
      }).whenComplete(() {
        processing = false;
        setState(() {
          imagesFileList = [];
          mainCategoryValue = 'Select Category';
          imagesUrlList = [];
          subCategoryList = [];
        });
      });
    } else {
      print('no images');
    }
  }

  void uploadProduct() async {
    await uploadImages().whenComplete(() => uploadData());
  }
/*
  void uploadProduct() async {
    if (mainCategoryValue != 'Select Category' &&
        subCategoryValue != 'SubCategory') {
      if (_formKey.currentState!.validate()) {
        // ignore: avoid_print
        _formKey.currentState!.save();

        if (imagesFileList!.isNotEmpty) {
          try {
            for (var image in imagesFileList!) {
              firebase_storage.Reference ref = firebase_storage
                  .FirebaseStorage.instance
                  .ref('products/${path.basename(image.path)}');

              await ref.putFile(File(image.path)).whenComplete(() async {
                await ref.getDownloadURL().then((value) {
                  imagesUrlList.add(value);
                }).whenComplete(() async {
                  CollectionReference productRef =
                      FirebaseFirestore.instance.collection('products');

                  await productRef.doc().set({
                    'maincategory': mainCategoryValue,
                    'subcategory': subCategoryValue,
                    'price': price,
                    'instock': quantity,
                    'productname': productName,
                    'productdesc': productDesc,
                    'sid': FirebaseAuth.instance.currentUser!.uid,
                    'productimages': imagesUrlList,
                    'discount': 0, // add discount later
                  });
                });
              });
            }
          } catch (e) {
            print(e);
          }

          print('images picked');
          print('valid');
          print(price);
          print(quantity);
          print(productName);
          print(productDesc);
          setState(() {
            imagesFileList = [];
            mainCategoryValue = 'Select Category';
            //subCategoryValue = 'SubCategory';
            subCategoryList = [];
          });
          _formKey.currentState!.reset();
        } else {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'Please choose product images !');
        }
      } else {
        MyMessageHandler.showSnackBar(_scaffoldKey, 'Please fill all fields');
      }
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'Please select categories');
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(
                                1.0,
                                1.0,
                              ),
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                            ), //BoxShadow
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                          color: Colors.grey,
                        ),
                        height: MediaQuery.of(context).size.width * 0.5,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: imagesFileList != null
                            ? previewsImages()
                            : const Center(
                                child: Text('No photos selected !'),
                              ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.5,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                const Text('Select main category',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red)),
                                Container(
                                  height: 30,
                                  width:
                                      MediaQuery.of(context).size.width * 0.52,
                                  decoration: const ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1.0, style: BorderStyle.solid),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        iconSize: 30,
                                        iconEnabledColor: Colors.red,
                                        dropdownColor: Colors.white,
                                        value: mainCategoryValue,
                                        items: maincategory
                                            .map<DropdownMenuItem<String>>(
                                                (value) {
                                          return DropdownMenuItem(
                                            child: Text(value),
                                            value: value,
                                          );
                                        }).toList(),
                                        onChanged: (String? value) {
                                          selectMainCategory(value);
                                        }),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text('Select  Subcategory',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red)),
                                Container(
                                  height: 30,
                                  width:
                                      MediaQuery.of(context).size.width * 0.52,
                                  decoration: const ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1.0, style: BorderStyle.solid),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        alignment: Alignment.center,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        iconSize: 30,
                                        iconEnabledColor: Colors.red,
                                        dropdownColor: Colors.white,
                                        iconDisabledColor: Colors.black,
                                        disabledHint: const Text(
                                            'Select Category first '),
                                        value: subCategoryValue,
                                        items: subCategoryList
                                            .map<DropdownMenuItem<String>>(
                                                (value) {
                                          return DropdownMenuItem(
                                            child: Text(value),
                                            value: value,
                                          );
                                        }).toList(),
                                        onChanged: (String? value) {
                                          print(value);
                                          setState(() {
                                            subCategoryValue = value!;
                                          });
                                        }),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                    child: Divider(
                      color: Color.fromARGB(255, 31, 129, 117),
                      thickness: 1.5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter price !';
                            } else if (value.isValidPrice() != true) {
                              return 'Invalid price';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            price = double.parse(value!);
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Price',
                            hintText: '\$',
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter quantity !';
                            } else if (value.isValidQuantity() != true) {
                              return 'Not valid quantity';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            quantity = int.parse(value!);
                          },
                          keyboardType: TextInputType.number,
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Quantity',
                            hintText: 'Add Quantity',
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter product name !';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          productName = value!;
                        },
                        maxLength: 100,
                        maxLines: 2,
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Product Name',
                          hintText: 'Enter product name',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter product description !';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          productDesc = value!;
                        },
                        maxLength: 900,
                        maxLines: 5,
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Product Description',
                          hintText: 'Enter product description',
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /* imagesFileList!.isEmpty
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          imagesFileList = [];
                        });
                      },
                      backgroundColor: const Color.fromARGB(255, 33, 221, 96),
                      child: const Icon(Icons.delete_outline_rounded),
                    ),
                  ), */
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FloatingActionButton(
                onPressed: imagesFileList!.isEmpty
                    ? () {
                        uploadProductImages();
                      }
                    : () {
                        setState(() {
                          imagesFileList = [];
                        });
                      },
                backgroundColor: const Color.fromARGB(255, 33, 221, 96),
                child: imagesFileList!.isEmpty
                    ? const Icon(Icons.photo_library)
                    : const Icon(Icons.delete_outline_rounded),
              ),
            ),
            FloatingActionButton(
              onPressed: processing == true
                  ? null
                  : () {
                      uploadProduct();
                    },
              backgroundColor: const Color.fromARGB(255, 33, 221, 96),
              child: processing == true
                  ? const CircularProgressIndicator(color: Colors.blue)
                  : const Icon(Icons.upload),
            )
          ],
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

extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'^((([1-9][0-9]*[\.]*)||([0][\.]*))([0-9]{1,2}))$')
        .hasMatch(this);
  }
}
