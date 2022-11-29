// ignore_for_file: avoid_print, duplicate_ignore

// ignore: avoid_web_libraries_in_flutter

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:final_techex_app/utilities/category_list.dart';
import 'package:final_techex_app/widgets/button2.dart';
import 'package:final_techex_app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class EditProduct extends StatefulWidget {
  final dynamic items;
  const EditProduct({Key? key, required this.items}) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late double price;
  late int quantity;
  late String productName;
  late String productDesc;
  late String productId;
  int? discount = 0;
  String mainCategoryValue = 'Select Category';
  String subCategoryValue = 'SubCategory';
  bool processing = false;

  List<String> subCategoryList = [];

  final ImagePicker _picker = ImagePicker();

  List<XFile>? imagesFileList = [];
  List<dynamic> imagesUrlList = [];
  dynamic _pickImageError;

  void uploadProductImages() async {
    try {
      final uploadedImages = await _picker.pickMultiImage(
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      setState(() {
        imagesFileList = uploadedImages;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      print(_pickImageError);
    }
  }

  Widget previewImages() {
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

  Widget previewCurrentImages() {
    List<dynamic> itemImages = widget.items['productimages'];
    return ListView.builder(
        itemCount: itemImages.length,
        itemBuilder: (context, index) {
          return Image.network(itemImages[index].toString());
        });
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

  Future uploadImages() async {
    if (mainCategoryValue != 'Select Category' &&
        subCategoryValue != 'SubCategory') {
      if (_formKey.currentState!.validate()) {
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
                });
              });
            }
          } catch (e) {
            print(e);
          }
        } else {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'Please select categories');
        }
      } else {
        imagesUrlList = widget.items['productimages'];
      }
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'Please fill all fields');
    }
  }

  editProductInfor() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('products')
          .doc(widget.items['productId']);
      transaction.update(documentReference, {
        'maincategory': mainCategoryValue,
        'subcategory': subCategoryValue,
        'price': price,
        'instock': quantity,
        'productname': productName,
        'productdesc': productDesc,
        'productimages': imagesUrlList,
        'discount': discount,
      });
    }).whenComplete(() => Navigator.pop(context));
  }

  saveChanges() async {
    await uploadImages().whenComplete(() => editProductInfor());
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
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
                              child: previewCurrentImages()),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.5,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    const Text('Main category',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red)),
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      margin: const EdgeInsets.all(6),
                                      constraints: BoxConstraints(
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3),
                                      decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                          child: Text(
                                              widget.items['maincategory'])),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text('Subcategory',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red)),
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      margin: const EdgeInsets.all(6),
                                      constraints: BoxConstraints(
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3),
                                      decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                          child: Text(
                                              widget.items['subcategory'])),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ExpandablePanel(
                          theme: const ExpandableThemeData(),
                          header: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.all(6),
                              child: const Center(
                                child: Text('Change Images & Categories',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          collapsed: const SizedBox(),
                          expanded: changeImages()),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                    child: Divider(
                      color: Color.fromARGB(255, 31, 129, 117),
                      thickness: 1.5,
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: TextFormField(
                              initialValue:
                                  widget.items['price'].toStringAsFixed(2),
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
                              keyboardType:
                                  const TextInputType.numberWithOptions(
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
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextFormField(
                              initialValue: widget.items['discount'].toString(),
                              maxLength: 2,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return null;
                                } else if (value.isValidDiscount() != true) {
                                  return 'Invalid discount';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                discount = int.parse(value!);
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: textFormDecoration.copyWith(
                                labelText: 'Discount',
                                hintText: 'discount .. %',
                              )),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextFormField(
                          initialValue: widget.items['instock'].toString(),
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
                        initialValue: widget.items['productname'],
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
                        initialValue: widget.items['productdesc'],
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
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Button2(
                              label: 'Cancel',
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              width: 0.4,
                              buttonColor: Colors.green),
                          Button2(
                              label: 'Save Changes',
                              onPressed: () {
                                saveChanges();
                              },
                              width: 0.4,
                              buttonColor: Colors.green),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Button2(
                          label: 'Delete Product',
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .runTransaction((transaction) async {
                              DocumentReference documentReference =
                                  FirebaseFirestore.instance
                                      .collection('products')
                                      .doc(widget.items['productId']);
                              transaction.delete(documentReference);
                            }).whenComplete(() => Navigator.pop(context));
                          },
                          width: 0.4,
                          buttonColor: Colors.red)
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget changeImages() {
    return Column(
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
                  ? previewImages()
                  : const Center(
                      child: Text('No photos selected !'),
                    ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.5,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                        width: MediaQuery.of(context).size.width * 0.52,
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1.0, style: BorderStyle.solid),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              borderRadius: BorderRadius.circular(12.0),
                              iconSize: 20,
                              iconEnabledColor: Colors.red,
                              dropdownColor: Colors.white,
                              value: mainCategoryValue,
                              items: maincategory
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem(
                                  child: Text(
                                    value,
                                    style: const TextStyle(fontSize: 15),
                                  ),
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
                        width: MediaQuery.of(context).size.width * 0.52,
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1.0, style: BorderStyle.solid),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(12.0),
                              iconSize: 20,
                              iconEnabledColor: Colors.red,
                              dropdownColor: Colors.white,
                              iconDisabledColor: Colors.black,
                              disabledHint: const Text(
                                'Select Category first ',
                              ),
                              value: subCategoryValue,
                              items: subCategoryList
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem(
                                  child: Text(
                                    value,
                                    style: const TextStyle(fontSize: 15),
                                  ),
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: imagesFileList!.isNotEmpty
              ? Button2(
                  label: 'Reset',
                  onPressed: () {
                    setState(() {
                      imagesFileList = [];
                    });
                  },
                  width: 0.6,
                  buttonColor: Colors.green)
              : Button2(
                  label: 'Change Images',
                  onPressed: () {
                    uploadProductImages();
                  },
                  width: 0.6,
                  buttonColor: Colors.green),
        )
      ],
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
    return RegExp(
            r'^((([1-9][0-9]*[\.]*)||([0][\.]*))([0-9]{1,2}))$') //fix it later
        .hasMatch(this);
  }
}

extension DiscountValidator on String {
  bool isValidDiscount() {
    return RegExp(r'^([0-9]*)$') //fix it later
        .hasMatch(this);
  }
}
