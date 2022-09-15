import 'package:flutter/material.dart';

import '../widgets/fake_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color.fromARGB(255, 31, 129, 117),
            title:
                const FakeSearch(), // Extract from inkwell to fakesearch widgets
            bottom: const TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              indicatorWeight: 4,
              tabs: [
                RepeatedTab(lable: 'Phone & Accessories'),
                RepeatedTab(lable: 'Electronic Device'),
                RepeatedTab(lable: 'Computer & Laptop'),
                RepeatedTab(lable: 'Camera & Camcorder'),
                RepeatedTab(lable: 'Smart Watch'),
                RepeatedTab(lable: 'Household Appliances'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Center(child: Text('Phone & accessories screen')),
              Center(child: Text('Electronic Device screen')),
              Center(child: Text('Computer & Laptop screen')),
              Center(child: Text('Camera & Camcorder screen')),
              Center(child: Text('Smart Watch screen')),
              Center(child: Text('Household Appliances screen')),
            ],
          )),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String lable;
  const RepeatedTab({Key? key, required this.lable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        lable,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
