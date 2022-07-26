import 'package:flutter/material.dart';

class SubCategoryProducts extends StatelessWidget {
  final String subcategName;
  final String maincategName;
  const SubCategoryProducts(
      {Key? key, required this.subcategName, required this.maincategName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 31, 129, 117),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          subcategName,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Text(maincategName),
      ),
    );
  }
}
