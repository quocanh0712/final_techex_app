import 'package:final_techex_app/providers/wish_provider.dart';
import 'package:final_techex_app/widgets/appbar_widgets.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
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
            leading: const AppBarBackButton(),
            title: const AppBarTitle(title: 'Wishlist'),
            /*  actions: [
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
            ], */
          ),
          body: context.watch<Wish>().getWishItems.isNotEmpty
              ? const WishItems()
              : const EmptyWishlist(),
        ),
      ),
    );
  }
}

class EmptyWishlist extends StatelessWidget {
  const EmptyWishlist({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Your Wishlist Is Empty !',
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
    );
  }
}

class WishItems extends StatelessWidget {
  const WishItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Wish>(
      builder: (context, wish, child) {
        return ListView.builder(
            itemCount: wish.count,
            itemBuilder: (context, index) {
              final product = wish.getWishItems[index];
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
                                          icon: const Icon(Icons.delete_rounded)),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.shopping_cart)),
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
            });
      },
    );
  }
}
