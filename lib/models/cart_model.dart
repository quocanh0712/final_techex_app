import 'package:final_techex_app/providers/cart_provider.dart';
import 'package:final_techex_app/providers/product_class.dart';
import 'package:final_techex_app/providers/wish_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class CartModel extends StatelessWidget {
  const CartModel({
    Key? key,
    required this.product,
    required this.cart
  }) : super(key: key);

  final Product product;
  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        child: SizedBox(
          height: 100,
          child: Row(children: [
            SizedBox(
              height: 100,
              width: 120,
              child: Image.network(product.imagesUrl[0]),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(0.9)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.price.toStringAsFixed(2),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        Container(
                          height: 35,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(25)),
                          child: Row(children: [
                            product.quantity == 1
                                ? IconButton(
                                    onPressed: () {
                                      showCupertinoModalPopup<void>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CupertinoActionSheet(
                                          title: const Text('Remove Item'),
                                          message: const Text(
                                              'Are you sure to remove this item ?'),
                                          actions: <CupertinoActionSheetAction>[
                                            CupertinoActionSheetAction(
                                              /// This parameter indicates the action would be a default
                                              /// defualt behavior, turns the action's text to bold text.

                                              onPressed: () async {
                                                context
                                                            .read<Wish>()
                                                            .getWishItems
                                                            .firstWhereOrNull(
                                                                (element) =>
                                                                    element
                                                                        .documentId ==
                                                                    product
                                                                        .documentId) !=
                                                        null
                                                    ? context
                                                        .read<Cart>()
                                                        .removeProduct(product)
                                                    : await context
                                                        .read<Wish>()
                                                        .addWishItem(
                                                          product.name,
                                                          product.price,
                                                          1,
                                                          product.inStock,
                                                          product.imagesUrl,
                                                          product.documentId,
                                                          product.suppId,
                                                        );
                                                context
                                                    .read<Cart>()
                                                    .removeProduct(product);
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                  'Move To Wishlist'),
                                            ),
                                            CupertinoActionSheetAction(
                                              onPressed: () {
                                                context
                                                    .read<Cart>()
                                                    .removeProduct(product);
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Delete Item',
                                              ),
                                            ),
                                          ],
                                          cancelButton: TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 20),
                                              )),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.delete_rounded,
                                      size: 18,
                                    ))
                                : IconButton(
                                    onPressed: () {
                                      cart.reduceByOne(product);
                                    },
                                    icon: const Icon(
                                      FontAwesomeIcons.minus,
                                      size: 18,
                                    )),
                            Text(
                              product.quantity.toString(),
                              style: product.quantity == product.inStock
                                  ? const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)
                                  : const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                onPressed: product.quantity == product.inStock
                                    ? null
                                    : () {
                                        cart.increment(product);
                                      },
                                icon: const Icon(
                                  FontAwesomeIcons.plus,
                                  size: 18,
                                ))
                          ]),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
