import 'package:final_techex_app/utilities/category_list.dart';
import 'package:flutter/material.dart';

import '../widgets/categ_widgets.dart';

class SmartWatchCategory extends StatelessWidget {
  const SmartWatchCategory({Key? key}) : super(key: key);

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
                    headerLabel: 'Smart Watch',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.67,
                    child: GridView.count(
                      mainAxisSpacing: 70,
                      crossAxisSpacing: 15,
                      crossAxisCount: 3,
                      children: List.generate(smartwatch.length, (index) {
                        return SubcategModel(
                          mainCategName: 'Smart Watch',
                          subCategName: smartwatch[index],
                          assetName: 'images/smartwatch/image$index.jpeg',
                          subcategLabel: smartwatch[index],
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
