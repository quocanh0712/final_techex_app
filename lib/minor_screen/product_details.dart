// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_techex_app/main_screens/cart.dart';
import 'package:final_techex_app/minor_screen/store_detail.dart';
import 'package:final_techex_app/minor_screen/full_screen_view.dart';
import 'package:final_techex_app/models/product_model.dart';
import 'package:final_techex_app/providers/cart_provider.dart';
import 'package:final_techex_app/providers/wish_provider.dart';
import 'package:final_techex_app/widgets/appbar_widgets.dart';
import 'package:final_techex_app/widgets/button.dart';
import 'package:final_techex_app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:collection/collection.dart';
import 'package:badges/badges.dart';
import 'package:expandable/expandable.dart';

class ProductDetailsScreen extends StatefulWidget {
  final dynamic productList;
  const ProductDetailsScreen({Key? key, required this.productList})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final Stream<QuerySnapshot> reviewsStream = FirebaseFirestore.instance
      .collection('products')
      .doc(widget.productList['productId'])
      .collection('reviews')
      .snapshots();

  late final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
      .collection('products')
      .where('maincategory', isEqualTo: widget.productList['maincategory'])
      .where('subcategory', isEqualTo: widget.productList['subcategory'])
      .snapshots();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late List<dynamic> imagesList = widget.productList['productimages'];
  @override
  Widget build(BuildContext context) {
    var existingItemCart = context.read<Cart>().getItems.firstWhereOrNull(
        // ignore: avoid_types_as_parameter_names
        (product) => product.documentId == widget.productList['productId']);
    return Material(
      child: SafeArea(
        top: false,
        child: ScaffoldMessenger(
          key: _scaffoldKey,
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
                              builder: (context) => FullScreenView(
                                    imagesList: imagesList,
                                  )));
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
                                  icon: const Icon(
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
                                  icon: const Icon(
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
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text('USD  ',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              Text(
                                widget.productList['price'].toStringAsFixed(2),
                                style: widget.productList['discount'] != 0
                                    ? const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.w600)
                                    : const TextStyle(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              widget.productList['discount'] != 0
                                  ? Text(
                                      ((1 -
                                                  (widget.productList[
                                                          'discount'] /
                                                      100)) *
                                              widget.productList['price'])
                                          .toStringAsFixed(2),
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    )
                                  : const Text(''),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                var existingItemWishlist = context
                                    .read<Wish>()
                                    .getWishItems
                                    .firstWhereOrNull((product) =>
                                        product.documentId ==
                                        widget.productList['productId']);
                                existingItemWishlist != null
                                    ? context.read<Wish>().removeItem(
                                        widget.productList['productId'])
                                    : context.read<Wish>().addWishItem(
                                          widget.productList['productname'],
                                          widget.productList['discount'] != 0
                                              ? ((1 -
                                                      (widget.productList[
                                                              'discount'] /
                                                          100)) *
                                                  widget.productList['price'])
                                              : widget.productList['price'],
                                          1,
                                          widget.productList['instock'],
                                          widget.productList['productimages'],
                                          widget.productList['productId'],
                                          widget.productList['sid'],
                                        );
                              },
                              icon: context
                                          .watch<Wish>()
                                          .getWishItems
                                          .firstWhereOrNull((product) =>
                                              product.documentId ==
                                              widget
                                                  .productList['productId']) !=
                                      null
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 30,
                                    )
                                  : const Icon(
                                      Icons.favorite_outline,
                                      color: Colors.red,
                                      size: 30,
                                    )),
                        ],
                      ),
                      widget.productList['instock'] == 0
                          ? const Text('This product is out of stock',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.blueGrey))
                          : Text(
                              (widget.productList['instock'].toString()) +
                                  (' products available in stock'),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.blueGrey)),
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
                  Stack(children: [
                    const Positioned(right: 50, top: 15, child: Text('total')),
                    ExpandableTheme(
                        data: const ExpandableThemeData(
                            iconSize: 30, iconColor: Colors.blue),
                        child: reviews(reviewsStream)),
                  ]),
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
            bottomSheet: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StoreDetail(
                                          supplierId:
                                              widget.productList['sid'])));
                            },
                            icon: const Icon(Icons.shop_2)),
                        const SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CartScreen(
                                    back: AppBarBackButton(),
                                  ),
                                ));
                          },
                          icon: Badge(
                            showBadge: context.read<Cart>().getItems.isEmpty
                                ? false
                                : true,
                            padding: const EdgeInsets.all(2),
                            badgeColor: const Color.fromARGB(255, 77, 230, 82),
                            badgeContent: Text(
                              context.watch<Cart>().getItems.length.toString(),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                            child: const Icon(Icons.shopping_cart),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Button(
                        label: existingItemCart != null
                            ? 'ADDED TO CART'
                            : 'ADD TO CART ',
                        onPressed: () {
                          if (widget.productList['instock'] == 0) {
                            MyMessageHandler.showSnackBar(
                                _scaffoldKey, 'This product is out of stock');
                          } else if (existingItemCart != null) {
                            MyMessageHandler.showSnackBar(_scaffoldKey,
                                'This product is already in cart');
                          } else {
                            context.read<Cart>().addItem(
                                  widget.productList['productname'],
                                  widget.productList['discount'] != 0
                                      ? ((1 -
                                              (widget.productList['discount'] /
                                                  100)) *
                                          widget.productList['price'])
                                      : widget.productList['price'],
                                  1,
                                  widget.productList['instock'],
                                  widget.productList['productimages'],
                                  widget.productList['productId'],
                                  widget.productList['sid'],
                                );
                          }
                        },
                        width: 0.5,
                        buttonColor: Colors.yellow),
                  )
                ]),
          ),
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
                color: Colors.blue,
                thickness: 1,
              )),
          Text(
            label,
            style: const TextStyle(
                color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
              height: 40,
              width: 50,
              child: Divider(
                color: Colors.blue,
                thickness: 1,
              )),
        ],
      ),
    );
  }
}

Widget reviews(reviewsStream) {
  return ExpandablePanel(
      header: const Padding(
        padding: EdgeInsets.all(10),
        child: Text('Reviews',
            style: TextStyle(
                color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      collapsed: SizedBox(
        height: 230,
        child: reviewsAll(reviewsStream),
      ),
      expanded: reviewsAll(reviewsStream));
}

Widget reviewsAll(var reviewsStream) {
  return StreamBuilder<QuerySnapshot>(
    stream: reviewsStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
      if (snapshot2.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (snapshot2.data!.docs.isEmpty) {
        return const Center(
            child: Text(
          'This Item \n has no reviews yet !',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ));
      }

      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot2.data!.docs.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage(snapshot2.data!.docs[index]['profileimage']),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(snapshot2.data!.docs[index]['name']),
                  Row(
                    children: [
                      Text(snapshot2.data!.docs[index]['rate'].toString()),
                      const Icon(Icons.star, color: Colors.yellow)
                    ],
                  )
                ],
              ),
              subtitle: Text(snapshot2.data!.docs[index]['comment']),
            );
          });
    },
  );
}
