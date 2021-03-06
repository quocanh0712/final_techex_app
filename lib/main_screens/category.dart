import 'package:final_techex_app/utilities/category_list.dart';
import 'package:final_techex_app/widgets/fake_search.dart';
import 'package:flutter/material.dart';

List<ItemsData> items = [
  ItemsData(lable: 'phone & accessories'),
  ItemsData(lable: 'electronic device'),
  ItemsData(lable: 'computer & laptop'),
  ItemsData(lable: 'camera & camcorder'),
  ItemsData(lable: 'smart watch'),
  ItemsData(lable: 'household appliances'),
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
      items[0].isSelected = true;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
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
                    ? Colors.white
                    : Colors.grey.shade300,
                height: 100,
                child: Center(
                  child: Text(items[index].lable),
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
          Center(child: Text('phone & accessories')),
          Center(child: Text('electronic device')),
          Center(child: Text('computer & laptop')),
          Center(child: Text('camera & camcorder')),
          Center(child: Text('smart watch')),
          Center(child: Text('household appliances')),
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
