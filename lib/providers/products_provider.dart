import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';
import 'package:shop/services/request_favorites.dart';
import 'package:shop/services/request_products.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];
  final String _token;
  final String _userId;
  bool inLoadingItens;

  RequestProducts requestProducts;
  RequestFavorites requestFavorites;

  ProductsProvider([this._token, this._userId]) {
    requestProducts = RequestProducts(_token, _userId);
    requestFavorites = RequestFavorites(_token, _userId);
    if (_token != null) getItems();
  }

  void getItems() async {
    inLoadingItens = true;
    _items = await requestProducts.getAll();
    inLoadingItens = false;
    notifyListeners();
  }

  List<Product> get items => List<Product>.from(_items);

  int get count => _items.length;

  List<Product> get itemsFavorite =>
      _items.where((prod) => prod.isFavorite).toList();

  void addItem(Product product) async{
    final idProd = await requestProducts.insert(product.toJson());
    product.id = idProd;
    _items.add(product);
    notifyListeners();
  }

  void updateItem(Product product) async {
    if (product == null || product.id == null) {
      return;
    }

    await requestProducts.update(product.id, product.toJson());

    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void removeItem(Product product) {
    if(product == null) {
      return;
    }

    requestProducts.delete(product.id);

    if (_items.contains(product)) {
      _items.removeWhere((prod) => prod.id == product.id);
      notifyListeners();
    }
  }

  void updateFavorite(Product product) {
    requestFavorites.updateFavorite(product.id, product.isFavorite);
  }
}
