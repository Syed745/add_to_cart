import 'package:flutter/material.dart';

class Cart extends ChangeNotifier {
  final List<Product> items = [];

  double get totalPrice => items.fold(0, (total, item) => total + item.price);

  void addToCart(Product product) {
    items.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    items.remove(product);
    notifyListeners();
  }
}

class Product {
  final String name;
  final double price;
  final String img;

  Product(this.name, this.price, this.img);
}
