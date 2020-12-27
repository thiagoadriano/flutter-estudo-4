import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shop/models/product.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;
  double total;

  CartItem({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.quantity,
    @required this.price,
  }) {
    total = price * quantity;
  }
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => Map.from(_items);

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;

    _items.forEach((key, value) {
      total += value.total;
    });

    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
          id: existingItem.id,
          productId: existingItem.productId,
          title: existingItem.title,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: Random().nextDouble().toString(),
          productId: product.id,
          title: product.title,
          quantity: 1,
          price: product.price,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId].quantity == 1) {
      _items.remove(productId);
    } else {
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          productId: existingItem.productId,
          title: existingItem.title,
          quantity: existingItem.quantity - 1,
          price: existingItem.price,
        ),
      );
    }

    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
