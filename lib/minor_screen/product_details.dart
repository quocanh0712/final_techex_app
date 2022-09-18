import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_techex_app/minor_screen/full_screen_view.dart';
import 'package:final_techex_app/models/product_model.dart';
import 'package:final_techex_app/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class ProductDetailsScreen extends StatefulWidget {
  final dynamic productList;
  const ProductDetailsScreen({Key? key, required this.productList})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late List<dynamic> imagesList = widget.productList['productimages'];
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection('products')
        .where('maincategory', isEqualTo: widget.productList['maincategory'])
        .where('subcategory', isEqualTo: widget.productList['subcategory'])
        .snapshots();
    return Material(
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.blueGrey.shade100.withOpacity(0.2),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Column(children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullScreenView(imagesList: imagesList,)));
                  },
                  child: Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: Swiper(
                            pagination: const SwiperPagination(
                                builder: SwiperPagination.dots),
                            itemBuilder: ((context, index) {
                              return Image(
                                image: NetworkImage(
                                  imagesList[index],
                                ),
                              );
                            }),
                            itemCount: imagesList.length),
                      ),
                      Positioned(
                          top: 40,
                          left: 15,
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                )),
                          )),
                      Positioned(
                          top: 40,
                          right: 15,
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                )),
                          ))
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productList['productname'],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'USD',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: 10),
                            Text(
                              widget.productList['price'].toStringAsFixed(2),
                              style: TextStyle(
                                  color: Colors.green,
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
                    Text(
                        (widget.productList['instock'].toString()) +
                            (' products available in stock'),
                        style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
                  ],
                ),
                const ProductDetailsHeader(
                  label: '  Product Description  ',
                ),
                Text(
                  widget.productList['productdesc'],
                  textScaleFactor: 1.1,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey.shade800),
                ),
                const ProductDetailsHeader(
                  label: '  Similar Products  ',
                ),
                Container(
                  color: Colors.blueGrey.shade100.withOpacity(0.2),
                  child: SizedBox(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _productStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                  ),
                )
              ]),
            ),
          ),
          bottomSheet:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
              ),
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
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Button(
                  label: 'ADD TO CART ',
                  onPressed: () {},
                  width: 0.5,
                  buttonColor: Colors.yellow),
            )
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
