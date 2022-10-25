import 'package:final_techex_app/minor_screen/edit_products.dart';
import 'package:final_techex_app/minor_screen/product_details.dart';
import 'package:final_techex_app/providers/wish_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ProductModel extends StatefulWidget {
  final dynamic products ;
  const ProductModel({Key? key, required this.products}) : super(key: key);

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                      productList: widget.products,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child: Container(
                      constraints:
                          const BoxConstraints(minHeight: 100, maxHeight: 250),
                      child: Image(
                          image: NetworkImage(
                              widget.products['productimages'][0])),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.products['productname'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text('\$',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 31, 129, 117),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  widget.products['price'].toString(),
                                  style: widget.products['discount'] != 0
                                      ? const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontWeight: FontWeight.w600)
                                      : const TextStyle(
                                          color:
                                              Color.fromARGB(255, 31, 129, 117),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                widget.products['discount'] != 0
                                    ? Text(
                                        ((1 -
                                                    (widget.products[
                                                            'discount'] /
                                                        100)) *
                                                widget.products['price'])
                                            .toStringAsFixed(2),
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 31, 129, 117),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      )
                                    : const Text(''),
                              ],
                            ),
                            widget.products['sid'] ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditProduct(
                                                    items: widget.products,
                                                  )));
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.red,
                                    ))
                                : IconButton(
                                    onPressed: () {
                                      var existingItemWishlist = context
                                          .read<Wish>()
                                          .getWishItems
                                          .firstWhereOrNull((product) =>
                                              product.documentId ==
                                              widget.products['productId']);
                                      existingItemWishlist != null
                                          ? context.read<Wish>().removeItem(
                                              widget.products['productId'])
                                          : context.read<Wish>().addWishItem(
                                                widget.products['productname'],
                                                widget.products['discount'] != 0
                                                    ? ((1 -
                                                            (widget.products[
                                                                    'discount'] /
                                                                100)) *
                                                        widget
                                                            .products['price'])
                                                    : widget.products['price'],
                                                1,
                                                widget.products['instock'],
                                                widget
                                                    .products['productimages'],
                                                widget.products['productId'],
                                                widget.products['sid'],
                                              );
                                    },
                                    icon: context
                                                .watch<Wish>()
                                                .getWishItems
                                                .firstWhereOrNull((product) =>
                                                    product.documentId ==
                                                    widget.products[
                                                        'productId']) !=
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            widget.products['discount'] != 0
                ? Positioned(
                    top: 30,
                    left: 0,
                    child: Container(
                      height: 25,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.greenAccent.shade400,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          )),
                      child: Center(
                        child: Text(
                            'Save ${widget.products['discount'].toString()} %'),
                      ),
                    ),
                  )
                : Container(
                    color: Colors.transparent,
                  )
          ],
        ),
      ),
    );
  }
}
