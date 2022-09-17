import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_techex_app/models/product_model.dart';
import 'package:final_techex_app/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final Stream<QuerySnapshot> _productStream =
      FirebaseFirestore.instance.collection('products').snapshots();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        top: false,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                child: Swiper(
                    pagination:
                        const SwiperPagination(builder: SwiperPagination.dots),
                    itemBuilder: ((context, index) {
                      return const Image(
                        image: NetworkImage(
                            'https://store.storeimages.cdn-apple.com/8756/as-images.apple.com/is/ipad-pro-12-select-wifi-spacegray-202104_GEO_MY?wid=940&hei=1112&fmt=p-jpg&qlt=95&.v=1617923129000'),
                      );
                    }),
                    itemCount: 1),
              ),
              const Text(
                'this is product name',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Text(
                        'USD',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '1999',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite_border_outlined,
                        color: Colors.red,
                        size: 30,
                      )),
                ],
              ),
              const Text('100 products available in stock',
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
              const ProductDetailsHeader(
                label: '  Product Description  ',
              ),
              Text(
                'this is product description ',
                textScaleFactor: 1.1,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey.shade800),
              ),
              const ProductDetailsHeader(
                label: '  Similar Products  ',
              ),
              SizedBox(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _productStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text(
                        'This category \n has no items yet !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5),
                      ));
                    }

                    return SingleChildScrollView(
                      child: StaggeredGridView.countBuilder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          crossAxisCount: 2,
                          itemBuilder: ((context, index) {
                            return ProductModel(
                              products: snapshot.data!.docs[index],
                            );
                          }),
                          staggeredTileBuilder: (context) =>
                              const StaggeredTile.fit(1)),
                    );
                  },
                ),
              )
            ]),
          ),
          bottomSheet:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.shop_2)),
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
                ],
              ),
            ),
            Button(
                label: 'ADD TO CART ',
                onPressed: () {},
                width: 0.5,
                buttonColor: Colors.yellow)
          ]),
        ),
      ),
    );
  }
}

class ProductDetailsHeader extends StatelessWidget {
  final String label;
  const ProductDetailsHeader({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
              height: 40,
              width: 50,
              child: Divider(
                color: Color.fromARGB(255, 59, 204, 73),
                thickness: 1,
              )),
          Text(
            label,
            style: const TextStyle(
                color: Color.fromARGB(255, 59, 204, 73),
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
              height: 40,
              width: 50,
              child: Divider(
                color: Color.fromARGB(255, 59, 204, 73),
                thickness: 1,
              )),
        ],
      ),
    );
  }
}
