import 'package:flutter/material.dart';

class Product {
  String name;
  double price;
  int quantity = 1;
  int inStock;
  List imagesUrl;
  String documentId;
  String suppId;
  Product({
    required this.name,
    required this.price,
    required this.quantity,
    required this.inStock,
    required this.imagesUrl,
    required this.documentId,
    required this.suppId,
  });
  void increaseQuantity() {
    quantity++;
  }

  void decreaseQuantity() {
    quantity--;
  }
}

class Cart extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getItems {
    return _list;
  }

  double get totalPrice {
    var total = 0.0;

    for (var item in _list) {
      total += item.price * item.quantity;
    }
    return total;
  }

  int? get count {
    return _list.length;
  }

  void addItem(
    String name,
    double price,
    int quantity,
    int inStock,
    List imagesUrl,
    String documentId,
    String suppId,
  ) {
    final product = Product(
        name: name,
        price: price,
        quantity: quantity,
        inStock: inStock,
        imagesUrl: imagesUrl,
        documentId: documentId,
        suppId: suppId);
    _list.add(product);
    notifyListeners();
  }

  void increment(Product product) {
    product.increaseQuantity();
    notifyListeners();
  }

  void reduceByOne(Product product) {
    product.decreaseQuantity();
    notifyListeners();
  }

  void removeProduct(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _list.clear();
    notifyListeners();
  }
}
