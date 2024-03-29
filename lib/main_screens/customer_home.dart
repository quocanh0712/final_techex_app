import 'package:badges/badges.dart';
import 'package:final_techex_app/main_screens/cart.dart';
import 'package:final_techex_app/main_screens/category.dart';
import 'package:final_techex_app/main_screens/profile.dart';
import 'package:final_techex_app/main_screens/stores.dart';
import 'package:final_techex_app/providers/cart_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    const HomeScreen(),
    const CategoryScreen(),
    const StoresScreen(),
    const CartScreen(),
    ProfileScreen(documentId: FirebaseAuth.instance.currentUser!.uid),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        backgroundColor: const Color.fromARGB(255, 31, 129, 117),
        selectedItemColor: Colors.amber.shade200,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Category',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Stores',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              showBadge: context.read<Cart>().getItems.isEmpty ? false : true,
              padding: const EdgeInsets.all(2),
              badgeColor: const Color.fromARGB(255, 77, 230, 82),
              badgeContent: Text(
                context.watch<Cart>().getItems.length.toString(),
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
