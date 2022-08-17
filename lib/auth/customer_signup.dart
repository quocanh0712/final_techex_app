// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import '../widgets/auth_widgets.dart';

class CustomerRegister extends StatefulWidget {
  const CustomerRegister({Key? key}) : super(key: key);

  @override
  State<CustomerRegister> createState() => _CustomerRegisterState();
}

class _CustomerRegisterState extends State<CustomerRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 50),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AuthHeaderLabel(
                headerLabel: 'Sign Up',
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Color.fromARGB(255, 31, 129, 117),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 31, 129, 117),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15))),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt_rounded,
                              color: Colors.white),
                          onPressed: () {
                            print('take a picture from camera');
                          },
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 31, 129, 117),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.photo_album,
                              color: Colors.white),
                          onPressed: () {
                            print('take a picture from gallery');
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
                      labelText: 'Full Name', hintText: 'Enter your Full Name'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  keyboardType: TextInputType
                      .emailAddress, // make the keyboard include @ and .
                  decoration: textFormDecoration.copyWith(
                      labelText: 'Email Address', hintText: 'Enter your Email'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  decoration: textFormDecoration.copyWith(
                      labelText: 'Password', hintText: 'Enter your password'),
                ),
              ),
              HaveAccount(
                haveAccount: 'Already have account ? ',
                actionLabel: 'Log In',
                onPressed: () {},
              ),
              AuthSignUpButton(
                signupButtonLabel: 'Sign Up',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
