import 'package:final_techex_app/widgets/button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../minor_screen/forgot_password.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/snackbar.dart';

class CustomerLogin extends StatefulWidget {
  const CustomerLogin({Key? key}) : super(key: key);

  @override
  State<CustomerLogin> createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  late String email;
  late String password;

  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = false;
  bool sendEmailVerification = false;

  void logIn() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        await FirebaseAuth.instance.currentUser!.reload();
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          _formKey.currentState!.reset();

          Navigator.pushReplacementNamed(context, '/customer_home');
        } else {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'Please verification your email.');
          setState(() {
            processing = false;
            sendEmailVerification = true;
          });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            processing = false;
          });
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          setState(() {
            processing = false;
          });
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'Wrong password provided for that user.');
        }
      }
    } else {
      setState(() {
        processing = false;
      });
      MyMessageHandler.showSnackBar(_scaffoldKey, 'Please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AuthHeaderLabel(headerLabel: 'Log In'),
                      SizedBox(
                        height: 50,
                        child: sendEmailVerification == true
                            ? Center(
                                child: Button2(
                                    label: 'Resend Email Verification',
                                    onPressed: () async {
                                      try {
                                        await FirebaseAuth.instance.currentUser!
                                            .sendEmailVerification();
                                      } catch (e) {
                                        // ignore: avoid_print
                                        print(e);
                                      }
                                      Future.delayed(const Duration(seconds: 3))
                                          .whenComplete(() {
                                        setState(() {
                                          sendEmailVerification = false;
                                        });
                                      });
                                    },
                                    width: 0.6,
                                    buttonColor: Colors.red),
                              )
                            : const SizedBox(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            } else if (value.isValidEmail() == false) {
                              return 'Invalid email';
                            } else if (value.isValidEmail() == true) {
                              return null;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            email = value;
                          },
                          //controller: _emailController,
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            password = value;
                          },
                          //controller: _passwordController,
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
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPassword()));
                          },
                          child: const Text('Forgot Password ?',
                              style: TextStyle(
                                  fontSize: 18, fontStyle: FontStyle.italic))),
                      processing == true
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.purple))
                          : AuthMainButton(
                              mainButtonLabel: 'Log In',
                              onPressed: () {
                                logIn();
                              },
                            ),
                      HaveAccount(
                        haveAccount: 'Don\'t have account ?',
                        actionLabel: 'Sign Up',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/customer_signup');
                        },
                      ),
                      divider(),
                      googleLoginButton()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(
            width: 80,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text(
            '  Or  ',
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
          SizedBox(
            width: 80,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget googleLoginButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 50, 50, 20),
      child: Material(
        elevation: 3,
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6),
        child: MaterialButton(
          onPressed: () async {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(
                FontAwesomeIcons.google,
                color: Colors.red,
              ),
              Text(
                'Sign In With Google',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ],
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
