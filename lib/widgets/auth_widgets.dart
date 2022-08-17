import 'package:flutter/material.dart';

class AuthSignUpButton extends StatelessWidget {
  final String signupButtonLabel;
  final Function() onPressed;
  const AuthSignUpButton(
      {Key? key, required this.signupButtonLabel, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 30,
      ),
      child: Material(
        color: Color.fromARGB(255, 31, 129, 117),
        borderRadius: BorderRadius.circular(25),
        child: MaterialButton(
            minWidth: double.infinity,
            onPressed: onPressed,
            child: Text(
              signupButtonLabel,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )),
      ),
    );
  }
}

class HaveAccount extends StatelessWidget {
  final String haveAccount;
  final String actionLabel;
  final Function() onPressed;
  const HaveAccount(
      {Key? key,
      required this.haveAccount,
      required this.actionLabel,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(haveAccount,
            style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
        TextButton(
          onPressed: onPressed,
          child: Text(actionLabel,
              style: const TextStyle(
                  color: Color.fromARGB(255, 31, 129, 117),
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
        ),
      ],
    );
  }
}

class AuthHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const AuthHeaderLabel({Key? key, required this.headerLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headerLabel,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/welcome_screen');
              },
              icon: const Icon(
                Icons.home,
                size: 40,
              ))
        ],
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: 'Full Name',
  hintText: 'Enter your full name',
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
  enabledBorder: OutlineInputBorder(
    borderSide:
        const BorderSide(color: Color.fromARGB(255, 31, 129, 117), width: 2),
    borderRadius: BorderRadius.circular(25),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
        const BorderSide(color: Color.fromARGB(255, 31, 129, 117), width: 2),
    borderRadius: BorderRadius.circular(25),
  ),
);

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^([a-zA-Z0-9]+)([\-\_\.]*)([a-zA-Z0-9]*)([@])([a-zA-Z0-9]{2,})([\.][a-zA-Z]{2,3})$')
        .hasMatch(this);
  }
}
