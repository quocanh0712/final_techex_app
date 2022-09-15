import 'package:final_techex_app/widgets/appbar_widgets.dart';
import 'package:flutter/material.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 31, 129, 117),
        title: const AppBarTitle(title: 'Balance '),
        leading: const AppBarBackButton(),
      ),
    );
  }
}
