import 'package:final_techex_app/widgets/appbar_widgets.dart';
import 'package:final_techex_app/widgets/button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: const AppBarBackButton(),
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 31, 129, 117),
          title: const AppBarTitle(
            title: 'Forgot Password ?',
          ),
        ),
        body: SafeArea(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'To reset your password ? \n\n Please Enter your email address \n and click on the button below',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        } else if (value.isValidEmailAddress() == false) {
                          return 'Invalid email';
                        } else if (value.isValidEmailAddress() == true) {
                          return null;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: textFormDecoration.copyWith(
                        labelText: 'Email Address',
                        hintText: 'Enter your email',
                      )),
                  const SizedBox(
                    height: 80,
                  ),
                  Button2(
                      label: 'Send Reset Password Link',
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: emailController.text);
                          } catch (e) {
                            // ignore: avoid_print
                            print(e);
                          }
                        } else {
                          // ignore: avoid_print
                          print('form not valid');
                        }
                      },
                      width: 0.7,
                      buttonColor: Colors.green)
                ],
              ),
            ),
          ),
        ));
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

extension EmailValidator on String {
  bool isValidEmailAddress() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
