import 'package:flutter/material.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/services/request_orders.dart';

class Order {
  String id;
  final double total;
  final List<CartItem> products;
  DateTime date = DateTime.now();

  Order({
    this.id,
    this.date,
    @required this.total,
    @required this.products,
  }) {
    this.date = this.date ?? DateTime.now();
  }
}

class Orders with ChangeNotifier {
  List<Order> _orders = [];
  final String _token;
  final String _userId;
  RequestOrders requestOrders;

  Orders([this._token, this._userId]) { 
    requestOrders = RequestOrders(_token, _userId);
  }

  Future<void> getOrdens() async {
    _orders = await requestOrders.getAll();
    notifyListeners();
    return Future.value();
  }

  List<Order> get orders => List.from(_orders);

  int get count => _orders.length;

  Future<void> addOrder(List<CartItem> products) async {
    final total = products.fold(0.0, (previousValue, item) => previousValue + item.total);
    final order = Order(
      total: total,
      products: products
    );

    final responseId = await requestOrders.insert({
      'total': order.total,
      'data': order.date.toString(),
      'products': products.map((prod) => {
          'id': prod.id,
          'productId': prod.productId,
          'title': prod.title,
          'quantity': prod.quantity,
          'price': prod.price,
          'total': prod.total,
      }).toList()
    });

    order.id = responseId;
    _orders.insert(0, order);
  }

}