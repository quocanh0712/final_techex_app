import 'package:flutter/material.dart';

import '../minor_screen/subcateg_products.dart';

class SliderBar extends StatelessWidget {
  const SliderBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.03,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50)),
        ),
      ),
    );
  }
}

class SubcategModel extends StatelessWidget {
  final String mainCategName;
  final String subCategName;
  final String assetName;
  final String subcategLabel;
  const SubcategModel(
      {Key? key,
      required this.mainCategName,
      required this.subCategName,
      required this.subcategLabel,
      required this.assetName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubCategoryProducts(
                      maincategName: mainCategName,
                      subcategName: subCategName,
                    )));
      },
      child: Column(
        children: [
          SizedBox(
            height: 60,
            width: 60,
            child: Image(
              image: AssetImage(
                  assetName), //the index is following the image index
            ),
          ),
          Text(
            subcategLabel,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class CategHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const CategHeaderLabel({Key? key, required this.headerLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Text(headerLabel,
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
    );
  }
}
