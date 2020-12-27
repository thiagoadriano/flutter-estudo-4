
import 'dart:convert';
import 'package:shop/services/request.dart';

class RequestFavorites extends Request {

  RequestFavorites(String _token, _userId): super('favorites/$_userId', _token);

  updateFavorite(String idProduct, bool statusFavorite) {
    return super.put(idProduct, json.encode(statusFavorite));
  }

  getFavorites() async{
    final response = await super.find();
    return json.decode(response.body) ?? {};
  }
}