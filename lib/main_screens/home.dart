import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../minor_screen/search.dart';

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
            backgroundColor: Colors.white,
            title: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchScreen()));
              },
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(154, 47, 97, 234), width: 1.4),
                    borderRadius: BorderRadius.circular(25)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(Icons.search,
                              color: Color.fromARGB(154, 47, 97, 234)),
                        ),
                        Text(
                          'What are you looking for ?',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                    Container(
                      height: 32,
                      width: 75,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(154, 47, 97, 234),
                          borderRadius: BorderRadius.circular(25)),
                      child: const Center(
                        child: Text(
                          'Search',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            bottom: const TabBar(
              isScrollable: true,
              indicatorColor: Color.fromARGB(154, 47, 97, 234),
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
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }
}
