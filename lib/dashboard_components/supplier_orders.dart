import 'package:final_techex_app/dashboard_components/delivered_orders.dart';
import 'package:final_techex_app/dashboard_components/preparing_orders.dart';
import 'package:final_techex_app/dashboard_components/shipping_orders.dart';
import 'package:final_techex_app/widgets/appbar_widgets.dart';
import 'package:flutter/material.dart';

class SupplierOrders extends StatelessWidget {
  const SupplierOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 31, 129, 117),
          title: const AppBarTitle(title: 'Orders'),
          leading: const AppBarBackButton(),
          bottom:
              const TabBar(indicatorColor: Colors.orange, indicatorWeight: 4, tabs: [
            RepeatedTab(label: 'Preparing'),
            RepeatedTab(label: 'Shipping'),
            RepeatedTab(label: 'Delivered'),
          ]),
        ),
        body: const TabBarView(children: [
          Preparing(),
          Shipping(),
          Delivered(),
        ]),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String label;
  const RepeatedTab({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Center(
          child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      )),
    );
  }
}
