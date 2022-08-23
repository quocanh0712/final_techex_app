import 'package:final_techex_app/categories/camera_category.dart';
import 'package:final_techex_app/categories/compute_category.dart';
import 'package:final_techex_app/categories/electronic_category.dart';
import 'package:final_techex_app/categories/householdappliances_category.dart';
import 'package:final_techex_app/categories/smartwatch_category.dart';
import 'package:final_techex_app/widgets/fake_search.dart';
import 'package:flutter/material.dart';

import '../categories/phone_category.dart';

List<ItemsData> items = [
  ItemsData(lable: 'Phone & Accessories'),
  ItemsData(lable: 'Electronic Device'),
  ItemsData(lable: 'Computer & Laptop'),
  ItemsData(lable: 'Camera & Camcorder'),
  ItemsData(lable: 'Smart Watch'),
  ItemsData(lable: 'Household Appliances'),
  ItemsData(lable: ''),
  ItemsData(lable: ''),
];

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    for (var element in items) {
      element.isSelected = false;
    }
    setState(() {
      items[0].isSelected =
          true; // Set 0 for item to return the new category view when change to another tab and turn back
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 31, 129, 117),
          title: const FakeSearch(),
        ),
        body: Stack(
          children: [
            Positioned(bottom: 0, left: 0, child: sideNavigator(size)),
            Positioned(bottom: 0, right: 0, child: categView(size))
          ],
        ));
  }

  Widget sideNavigator(Size size) {
    return SizedBox(
      height: size.height * 0.8,
      width: size.width * 0.2,
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.decelerate); // jump to page animation
                /* for (var element in items) {
                  element.isSelected = false;
                }
                setState(() {
                  items[index].isSelected = true;
                }); */
              },
              child: Container(
                color: items[index].isSelected == true
                    ? const Color.fromARGB(255, 125, 209, 198)
                    : Colors.white,
                height: 100,
                child: Center(
                  child: Text(items[index].lable,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 31, 129, 117))),
                ),
              ),
            );
          }),
    );
  }

  Widget categView(Size size) {
    return Container(
      height: size.height * 0.8,
      width: size.width * 0.8,
      color: Colors.white,
      child: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          for (var element in items) {
            element.isSelected = false;
          }
          setState(() {
            items[value].isSelected = true;
          });
        },
        scrollDirection: Axis.vertical,
        children: const [
          PhoneCategory(),
          ElectronicDeviceCategory(),
          ComputerAndLaptopCategory(),
          CameraAndCamcorderCategory(),
          SmartWatchCategory(),
          HouseholdAppliancesCategory(),
        ],
      ),
    );
  }
}

class ItemsData {
  String lable;
  bool isSelected;
  ItemsData({required this.lable, this.isSelected = false});
}
