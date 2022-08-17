import 'package:flutter/material.dart';

import '../widgets/appbar_widgets.dart';

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
        backgroundColor: const Color.fromARGB(255, 31, 129, 117),
        leading: const AppBarBackButton(),
        title: AppBarTitle(title: subcategName),
      ),
      body: Center(
        child: Text(maincategName),
      ),
    );
  }
}
