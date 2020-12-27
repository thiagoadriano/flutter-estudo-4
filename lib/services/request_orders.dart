import 'dart:convert';

import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/services/request.dart';

class RequestOrders extends Request {
  RequestOrders(String _token, String _userId) : super('orders/$_userId', _token);

  _parseOrders(Map<String, dynamic> objects) {
    List<Order> result = [];
    objects.forEach((key, values) {
      result.add(Order(
        id: key,
        total: values['total'],
        date: DateTime.tryParse(values['data']),
        products: (values['products'] as List<dynamic>).map((values) {
          return CartItem(
              id: values['id'],
              productId: values['productId'],
              title: values['title'],
              quantity: values['quantity'],
              price: values['price'],
            );
          }).toList()
        ),
      );
    });
    return result;
  }

  getAll() async {
    final response = await super.find();
    final decode = json.decode(response.body);
    if (decode == null) return [];
    return _parseOrders(decode);
  }

  insert(order) {
    return super
        .post(json.encode(order))
        .then((response) => json.decode(response.body)['name']);
  }

  update(id, order) {
    return super.patch(id, order);
  }
}
