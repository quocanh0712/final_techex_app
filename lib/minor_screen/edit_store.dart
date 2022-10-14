import 'dart:io';

import 'package:final_techex_app/widgets/appbar_widgets.dart';
import 'package:final_techex_app/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditStore extends StatefulWidget {
  final dynamic data;
  const EditStore({Key? key, required this.data}) : super(key: key);

  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  XFile? imageLogo;
  dynamic _pickImageError;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarBackButton(),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 31, 129, 117),
        title: const AppBarTitle(title: 'Edit Store'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 31, 129, 117), width: 3.0)),
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
                            Button(
                                label: 'Change',
                                onPressed: () {
                                  pickStoreLogo();
                                },
                                width: 0.25,
                                buttonColor: const Color.fromARGB(255, 31, 129, 117)),
                            const SizedBox(
                              height: 10,
                            ),
                            imageLogo == null
                                ? const SizedBox()
                                : Button(
                                    label: 'Reset',
                                    onPressed: () {
                                      setState(() {
                                        imageLogo = null;
                                      });
                                    },
                                    width: 0.25,
                                    buttonColor:
                                        const Color.fromARGB(255, 31, 129, 117)),
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
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Divider(
                        color: Color.fromARGB(255, 31, 129, 117),
                        thickness: 2.5,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
