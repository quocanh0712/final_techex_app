import 'package:final_techex_app/utilities/category_list.dart';
import 'package:flutter/material.dart';

import '../widgets/categ_widgets.dart';

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
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CategHeaderLabel(
                    headerLabel: 'Phone & Accessories',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.67,
                    child: GridView.count(
                      mainAxisSpacing: 70,
                      crossAxisSpacing: 15,
                      crossAxisCount: 3,
                      children: List.generate(phoneandaccessories.length - 1,
                          (index) {
                        return SubcategModel(
                          mainCategName: 'Phone & Accessories',
                          subCategName: phoneandaccessories[index + 1],
                          assetName: 'images/phone/image$index.jpeg',
                          subcategLabel: phoneandaccessories[index + 1],
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Positioned(
            top: 0,
            right: 0,
            child: SliderBar(),
          ),
        ],
      ),
    );
  }
}
