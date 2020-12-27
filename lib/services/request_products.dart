
import 'dart:convert';

import 'package:shop/models/product.dart';
import 'package:shop/services/request.dart';
import 'package:shop/services/request_favorites.dart';

class RequestProducts extends Request {
  RequestFavorites requestFavorites;

  RequestProducts(String _token, String _userId): super('products', _token) {
    requestFavorites = RequestFavorites(_token, _userId);
  }

  _parseProducts(Map<String, dynamic> objects) async {
    List<Product> result = [];
    var mapFavorites = await requestFavorites.getFavorites();
    objects.forEach((key, values) {
      result.add(Product(
        id: key,
        title: values['title'],
        price: values['price'],
        description: values['description'],
        imageUrl: values['imageUrl'],
        isFavorite: mapFavorites.containsKey(key) ? mapFavorites[key] : false
      ));
    });
    return result;
  }

  getAll() async {
    final response = await super.find();
    final decode = json.decode(response.body);
    if (decode == null) return [];
    return _parseProducts(decode);
  }

  insert(product) {
    return super.post(product).then((response) => json.decode(response.body)['name']);
  }

  update(id, product) {
    return super.patch(id, product);
  }
}