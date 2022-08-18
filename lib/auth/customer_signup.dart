// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import '../widgets/auth_widgets.dart';

class CustomerRegister extends StatefulWidget {
  const CustomerRegister({Key? key}) : super(key: key);

  @override
  State<CustomerRegister> createState() => _CustomerRegisterState();
}

class _CustomerRegisterState extends State<CustomerRegister> {
  bool passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const AuthHeaderLabel(headerLabel: 'Sign Up'),
                  Row(
                    children: [
                      const Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 40),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.green,
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                print('take picture from camera');
                              },
                            ),
                          ),
                          const SizedBox(height: 7),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.photo_album,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                print('take picture from gallery');
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      decoration: textFormDecoration.copyWith(
                        labelText: 'Full Name',
                        hintText: 'Enter your full name',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: textFormDecoration.copyWith(
                        labelText: 'Email Address',
                        hintText: 'Enter your email ',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      obscureText: passwordVisible,
                      decoration: textFormDecoration.copyWith(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            icon: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black)),
                        labelText: 'Password',
                        hintText: 'Enter your password',
                      ),
                    ),
                  ),
                  HaveAccount(
                    haveAccount: 'already have account ?',
                    actionLabel: 'Log In',
                    onPressed: () {},
                  ),
                  AuthMainButton(
                    mainButtonLabel: 'Sign Up',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
