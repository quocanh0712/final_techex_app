import 'package:final_techex_app/utilities/category_list.dart';
import 'package:flutter/material.dart';

import '../widgets/categ_widgets.dart';

class ElectronicDeviceCategory extends StatelessWidget {
  const ElectronicDeviceCategory({Key? key}) : super(key: key);

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
                    headerLabel: 'Electronic Device',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.67,
                    child: GridView.count(
                      mainAxisSpacing: 70,
                      crossAxisSpacing: 15,
                      crossAxisCount: 3,
                      children: List.generate(electronicdevice.length, (index) {
                        return SubcategModel(
                          mainCategName: 'Electronic Device',
                          subCategName: electronicdevice[index],
                          assetName: 'images/electronicdevice/image$index.jpeg',
                          subcategLabel: electronicdevice[index],
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
