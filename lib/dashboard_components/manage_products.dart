import 'package:final_techex_app/widgets/appbar_widgets.dart';
import 'package:flutter/material.dart';

class ManageProducts extends StatelessWidget {
  const ManageProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 31, 129, 117),
        title: const AppBarTitle(title: 'Manage Products'),
        leading: const AppBarBackButton(),
      ),
    );
  }
}
