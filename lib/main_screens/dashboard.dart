import 'package:final_techex_app/dashboard_components/edit_profile.dart';
import 'package:final_techex_app/dashboard_components/manage_products.dart';
import 'package:final_techex_app/dashboard_components/my_store.dart';
import 'package:final_techex_app/dashboard_components/supplier_balance.dart';
import 'package:final_techex_app/dashboard_components/supplier_orders.dart';
import 'package:final_techex_app/dashboard_components/supplier_statics.dart';
import 'package:final_techex_app/main_screens/profile.dart';
import 'package:final_techex_app/widgets/appbar_widgets.dart';
import 'package:flutter/material.dart';

List<String> label = [
  'my store',
  'orders',
  'edit profile',
  'manage products',
  'balance',
  'statics'
];

List<IconData> icons = [
  Icons.store,
  Icons.shop_2_outlined,
  Icons.edit,
  Icons.settings,
  Icons.attach_money,
  Icons.show_chart,
];

List<Widget> pages = [
  MyStore(),
  SupplierOrders(),
  EditBusiness(),
  ManageProducts(),
  BalanceScreen(),
  StaticsScreen(),
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 31, 129, 117),
        title: const AppBarTitle(title: 'Dashboard'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/welcome_screen');
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: GridView.count(
          mainAxisSpacing: 50,
          crossAxisSpacing: 50,
          crossAxisCount: 2,
          children: List.generate(6, (index) {
            return InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => pages[index]));
              },
              child: Card(
                color: Color.fromARGB(255, 31, 129, 117),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      icons[index],
                      color: Colors.white,
                      size: 50,
                    ),
                    Text(
                      label[index].toUpperCase(),
                      style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontFamily: 'Monda'),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
