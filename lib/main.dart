import 'package:flutter/material.dart';

import 'main_screens/customer_home.dart';

void main() {
  runApp(const MyApp());
  // This is main app
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomerHomeScreen(),
    );
  }
}
