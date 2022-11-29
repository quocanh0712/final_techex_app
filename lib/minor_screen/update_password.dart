// ignore_for_file: avoid_print

import 'package:final_techex_app/providers/auth_repo.dart';
import 'package:final_techex_app/widgets/appbar_widgets.dart';
import 'package:final_techex_app/widgets/button2.dart';
import 'package:final_techex_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool checkPassword = true;
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 31, 129, 117),
          title: const AppBarTitle(title: 'Change Password'),
          leading: const AppBarBackButton(),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 30),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Text(
                    'To change your password please fill in the form below and click Save Changes',
                    style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 1.1,
                        color: Colors.blueGrey,
                        fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your password';
                        }
                        return null;
                      },
                      controller: oldPasswordController,
                      decoration: passwordFormDecoration.copyWith(
                          labelText: 'Old Password',
                          hintText: 'Enter your Current Password',
                          errorText: checkPassword != true
                              ? 'Not valid password'
                              : null),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter New Password';
                        }
                        return null;
                      },
                      controller: newPasswordController,
                      decoration: passwordFormDecoration.copyWith(
                          labelText: 'New Password',
                          hintText: 'Enter your New Password'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      validator: (value) {
                        if (value != newPasswordController.text) {
                          return 'Password Not Maching';
                        } else if (value!.isEmpty) {
                          return 'Re-enter New Password';
                        }
                        return null;
                      },
                      decoration: passwordFormDecoration.copyWith(
                          labelText: 'Repeat Password',
                          hintText: 'Re-Enter your New Password'),
                    ),
                  ),
                  FlutterPwValidator(
                      controller: newPasswordController,
                      minLength: 8,
                      uppercaseCharCount: 1,
                      numericCharCount: 2,
                      width: 400,
                      height: 150,
                      onSuccess: () {},
                      onFail: () {}),
                  Button2(
                      label: 'Save Changes',
                      onPressed: () async {
                        print(FirebaseAuth.instance.currentUser);
                        if (formKey.currentState!.validate()) {
                          checkPassword = await AuthRepo.checkOldPassword(
                              FirebaseAuth.instance.currentUser!.email!,
                              oldPasswordController.text);

                          setState(() {});
                          checkPassword == true
                              ? await FirebaseAuth.instance.currentUser!
                                  .updatePassword(newPasswordController.text)
                                  .whenComplete(() {
                                  formKey.currentState!.reset();
                                  newPasswordController.clear();
                                  oldPasswordController.clear();
                                  MyMessageHandler.showSnackBar(scaffoldKey,
                                      'Your Password Has Been Updated');
                                  Future.delayed(const Duration(seconds: 2))
                                      .whenComplete(
                                          () => Navigator.pop(context));
                                })
                              : print('not valid old password');
                          print('form valid');
                        } else {
                          print('form not valid');
                        }
                      },
                      width: 0.7,
                      buttonColor: Colors.green)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

var passwordFormDecoration = InputDecoration(
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
