import 'package:http/http.dart' as http;

class Request {
  final url = 'https://flutter-estudo-40046-default-rtdb.firebaseio.com/';
  final String entity;
  String uri;
  final String _token;

  Request(this.entity, this._token) {
    this.uri = '$url$entity';
  }

  Future<http.Response> find() {
    return http.get('$uri.json?auth=${_token}');
  }

  Future<http.Response> findOne(String id) {
    return http.get('$uri/$id.json?auth=${_token}');
  }

  Future<http.Response> post(body) {
    return http.post('$uri.json?auth=${_token}', body: body);
  }

  Future<http.Response> put(String id, body) {
    return http.put('$uri/$id.json?auth=${_token}', body: body);
  }

  Future<http.Response> patch(String id, body) {
    return http.patch('$uri/$id.json?auth=${_token}', body: body);
  }

  Future<http.Response> delete(String id) {
    return http.delete('$uri/$id.json?auth=${_token}');
  }

}