import 'package:final_techex_app/utilities/category_list.dart';
import 'package:flutter/material.dart';

import '../minor_screen/subcateg_products.dart';

/*List<String> imagePhone = [
  'images/phone/image0.jpeg',
  'images/phone/image1.jpeg',
  'images/phone/image2.jpeg',
  'images/phone/image3.jpeg',
  'images/phone/image4.jpeg',
  'images/phone/image5.jpeg',
  'images/phone/image6.jpeg',
  'images/phone/image7.jpeg',
  'images/phone/image8.jpeg',
  'images/phone/image9.jpeg',
  'images/phone/image10.jpeg'
]; */

/*List<String> lablePhone = [
  'Phone',
  'Tablet',
  'Backup Charger',
  'Battery and Charger',
  'Phone Case , Sticker',
  'Screen Protector',
  'Memory Card',
  'Sim',
  'Landline',
  'Other',
]; */

class PhoneCategory extends StatelessWidget {
  const PhoneCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(30.0),
          child: Text('Phone & Accessories',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5)),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.68,
          child: GridView.count(
            mainAxisSpacing: 70,
            crossAxisSpacing: 15,
            crossAxisCount: 3,
            children: List.generate(phoneandaccessories.length, (index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubCategoryProducts(
                                maincategName: 'phoneandaccessories',
                                subcategName: phoneandaccessories[index],
                              )));
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: Image(
                        image: AssetImage(
                            'images/phone/image$index.jpeg'), //the index is following the image index
                      ),
                    ),
                    Text(
                      phoneandaccessories[index],
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}
