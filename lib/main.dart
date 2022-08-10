import 'package:final_techex_app/main_screens/supplier_home.dart';
import 'package:flutter/material.dart';

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
      home: SupplierHomeScreen(),
    );
  }
}
