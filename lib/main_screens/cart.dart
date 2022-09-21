import 'package:final_techex_app/providers/cart_provider.dart';
import 'package:final_techex_app/providers/wish_provider.dart';
import 'package:final_techex_app/widgets/alert_dialog.dart';
import 'package:final_techex_app/widgets/appbar_widgets.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../widgets/button.dart';
import 'package:collection/collection.dart';

class CartScreen extends StatefulWidget {
  final Widget? back;
  const CartScreen({Key? key, this.back}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.blueGrey.shade100.withOpacity(1),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color.fromARGB(255, 31, 129, 117),
            leading: widget.back,
            title: const AppBarTitle(title: 'Cart'),
            actions: [
              context.watch<Cart>().getItems.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        MyAlertDialog.showDialog(
                            context: context,
                            title: 'Clear Cart',
                            content: 'Are you sure to clear cart ?',
                            tabNo: () {
                              Navigator.pop(context);
                            },
                            tabYes: () {
                              context.read<Cart>().clearCart();
                              Navigator.pop(
                                context,
                              );
                            });
                      },
                      icon:
                          const Icon(Icons.delete_forever, color: Colors.white))
            ],
          ),
          body: context.watch<Cart>().getItems.isNotEmpty
              ? const CartItems()
              : const EmptyCart(),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'TOTAL: \$ ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      context.watch<Cart>().totalPrice.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ],
                ),
                Button(
                  width: 0.30,
                  label: 'CHECK OUT',
                  onPressed: () {},
                  buttonColor: Colors.yellow,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your Cart Is Empty !',
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(height: 50),
          Material(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(25),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.5,
              onPressed: () {
                Navigator.canPop(context)
                    ? Navigator.pop(context)
                    : Navigator.pushReplacementNamed(
                        context, '/customer_home'); //forward to homescreen
              },
              child: const Text('continue shopping',
                  style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }
}

class CartItems extends StatelessWidget {
  const CartItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return ListView.builder(
            itemCount: cart.count,
            itemBuilder: (context, index) {
              final product = cart.getItems[index];
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
                                  Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Row(children: [
                                      product.quantity == 1
                                          ? IconButton(
                                              onPressed: () {
                                                showCupertinoModalPopup<void>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          CupertinoActionSheet(
                                                    title: const Text(
                                                        'Remove Item'),
                                                    message: const Text(
                                                        'Are you sure to remove this item ?'),
                                                    actions: <
                                                        CupertinoActionSheetAction>[
                                                      CupertinoActionSheetAction(
                                                        /// This parameter indicates the action would be a default
                                                        /// defualt behavior, turns the action's text to bold text.

                                                        onPressed: () async {
                                                          context
                                                                      .read<
                                                                          Wish>()
                                                                      .getWishItems
                                                                      .firstWhereOrNull((element) =>
                                                                          element
                                                                              .documentId ==
                                                                          product
                                                                              .documentId) !=
                                                                  null
                                                              ? context
                                                                  .read<Cart>()
                                                                  .removeProduct(
                                                                      product)
                                                              : await context
                                                                  .read<Wish>()
                                                                  .addWishItem(
                                                                    product
                                                                        .name,
                                                                    product
                                                                        .price,
                                                                    1,
                                                                    product
                                                                        .inStock,
                                                                    product
                                                                        .imagesUrl,
                                                                    product
                                                                        .documentId,
                                                                    product
                                                                        .suppId,
                                                                  );
                                                          context
                                                              .read<Cart>()
                                                              .removeProduct(
                                                                  product);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Move To Wishlist'),
                                                      ),
                                                      CupertinoActionSheetAction(
                                                        onPressed: () {
                                                          context
                                                              .read<Cart>()
                                                              .removeProduct(
                                                                  product);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          'Delete Item',
                                                        ),
                                                      ),
                                                    ],
                                                    cancelButton: TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
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
                                        style: product.quantity ==
                                                product.inStock
                                            ? const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red)
                                            : const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                          onPressed: product.quantity ==
                                                  product.inStock
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
            });
      },
    );
  }
}
