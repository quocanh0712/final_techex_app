import 'package:final_techex_app/providers/cart_provider.dart';
import 'package:final_techex_app/widgets/alert_dialog.dart';
import 'package:final_techex_app/widgets/appbar_widgets.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../widgets/button.dart';

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
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  child: SizedBox(
                    height: 100,
                    child: Row(children: [
                      SizedBox(
                        height: 100,
                        width: 120,
                        child: Image.network(cart.getItems[index].imagesUrl[0]),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                cart.getItems[index].name,
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
                                    cart.getItems[index].price
                                        .toStringAsFixed(2),
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
                                      cart.getItems[index].quantity == 1
                                          ? IconButton(
                                              onPressed: () {
                                                cart.removeProduct(
                                                    cart.getItems[index]);
                                              },
                                              icon: const Icon(
                                                Icons.delete_rounded,
                                                size: 18,
                                              ))
                                          : IconButton(
                                              onPressed: () {
                                                cart.reduceByOne(
                                                    cart.getItems[index]);
                                              },
                                              icon: const Icon(
                                                FontAwesomeIcons.minus,
                                                size: 18,
                                              )),
                                      Text(
                                        cart.getItems[index].quantity
                                            .toString(),
                                        style: cart.getItems[index].quantity ==
                                                cart.getItems[index].inStock
                                            ? const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red)
                                            : const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                          onPressed: cart.getItems[index]
                                                      .quantity ==
                                                  cart.getItems[index].inStock
                                              ? null
                                              : () {
                                                  cart.increment(
                                                      cart.getItems[index]);
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
