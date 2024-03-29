import 'package:final_techex_app/auth/customer_signup.dart';
import 'package:final_techex_app/auth/supplier_signup.dart';
import 'package:final_techex_app/main_screens/customer_home.dart';
import 'package:final_techex_app/main_screens/onboarding_screen.dart';
import 'package:final_techex_app/main_screens/supplier_home.dart';
import 'package:final_techex_app/main_screens/welcome_screen.dart';
import 'package:final_techex_app/providers/cart_provider.dart';
import 'package:final_techex_app/providers/stripe_id.dart';
import 'package:final_techex_app/providers/wish_provider.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

import 'auth/customer_login.dart';
import 'auth/supplier_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Cart()),
    ChangeNotifierProvider(create: (_) => Wish())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: WelcomeScreen(),
      initialRoute: '/onboarding_screen',
      routes: {
        '/welcome_screen': (context) => const WelcomeScreen(),
        '/onboarding_screen': (context) => const OnBoardingScreen(),
        '/customer_home': (context) => const CustomerHomeScreen(),
        '/supplier_home': (context) => const SupplierHomeScreen(),
        '/customer_signup': (context) => const CustomerRegister(),
        '/customer_login': (context) => const CustomerLogin(),
        '/supplier_login': (context) => const SupplierLogin(),
        '/supplier_signup': (context) => const SupplierRegister(),
      },
    );
  }
}
