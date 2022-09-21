
import 'package:final_techex_app/providers/product_class.dart';
import 'package:final_techex_app/providers/wish_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../providers/cart_provider.dart';

class WishlistModel extends StatelessWidget {
  const WishlistModel({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

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
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.price.toStringAsFixed(2),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  context
                                      .read<Wish>()
                                      .removeProduct(product);
                                },
                                icon:
                                    const Icon(Icons.delete_rounded)),
                            const SizedBox(
                              width: 10,
                            ),
                            context
                                        .watch<Cart>()
                                        .getItems
                                        .firstWhereOrNull(
                                            // ignore: avoid_types_as_parameter_names
                                            (element) =>
                                                element.documentId ==
                                                product.documentId) !=
                                    null
                                ? const SizedBox()
                                : IconButton(
                                    onPressed: () {
                                     
                                      context.read<Cart>().addItem(
                                            product.name,
                                            product.price,
                                            1,
                                            product.inStock,
                                            product.imagesUrl,
                                            product.documentId,
                                            product.suppId,
                                          );
                                    },
                                    icon: const Icon(
                                        Icons.shopping_cart)),
                          ],
                        ),
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