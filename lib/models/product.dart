
import 'dart:convert';

import 'package:flutter/foundation.dart';


class Product with ChangeNotifier {
  String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void toogleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  toJson() {
    return json.encode({
      "title": title,
      "description": description,
      "price": price,
      "imageUrl": imageUrl,
    });
  }
}