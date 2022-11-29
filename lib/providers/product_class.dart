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