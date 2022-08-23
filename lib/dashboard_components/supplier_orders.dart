import 'package:final_techex_app/widgets/appbar_widgets.dart';
import 'package:flutter/material.dart';

class SupplierOrders extends StatelessWidget {
  const SupplierOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 31, 129, 117),
        title: const AppBarTitle(title: 'Supplier Orders'),
        leading: const AppBarBackButton(),
      ),
    );
  }
}
