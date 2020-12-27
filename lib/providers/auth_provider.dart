import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop/data/store.dart';
import 'dart:convert';

import 'package:shop/exceptions/auth_exception.dart';

class AuthProvider with ChangeNotifier {
  static const _url = 'https://identitytoolkit.googleapis.com/v1/accounts';
  static const _key = 'AIzaSyCDY81GEmLSVDLSCN9PaKN5_71qp2juk1o';

  String _token;
  DateTime _expiresDate;
  String _userId;
  Timer _timerlogout;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return isAuth ? _userId : null;
  }

  String get token {
    if (_token != null &&
        _expiresDate != null &&
        _expiresDate.isAfter(DateTime.now())
    ) {
      return _token;
    }
    return null;
  }

  Future<void> authenticated(String email, String password, String segment) async {
    final uri = '$_url:$segment?key=$_key';

    final response = await post(
      uri,
      body: json.encode(
        {
          "email": email,
          "password": password,
          "returnSecureToken": true,
        },
      ),
    );

    final responseBody = json.decode(response.body);

    if (responseBody['error'] != null) {
      throw AuthException(responseBody['error']['message']);
    } else {
      _token = responseBody['idToken'];
      _userId = responseBody['localId'];
      _expiresDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseBody['expiresIn']),
        ),
      );
      Store.saveMap('userData', {
        "token": _token,
        "userId": _userId,
        "expiresDate": _expiresDate.toIso8601String()
      });
      autoLogout();
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> signup(String email, String password) async {
    return await authenticated(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return await authenticated(email, password, 'signInWithPassword');
  }

  Future<void> tryAutoLogin() async {
    if (isAuth || Store.has('userData')) return Future.value();

    final userData = await Store.getMap('userData');
    final expires = DateTime.parse(userData['expiresDate']);

    if (expires.isBefore(DateTime.now())) {
      Store.delete('userData');
      return Future.value();
    }

    _expiresDate = expires;
    _token = userData['token'];
    _userId = userData['userId'];
    return Future.value();
  }
  
  void logout() {
    _token = null;
    _userId = null;
    _expiresDate = null;
    if (_timerlogout != null) {
      _timerlogout.cancel();
      _timerlogout = null;
    }
    notifyListeners();
  }

  void autoLogout() {
    if (_timerlogout != null) {
      _timerlogout.cancel();
    }
    _timerlogout = Timer(
      Duration(
        seconds: _expiresDate.difference(DateTime.now()).inSeconds
      ), 
      logout
    );
  }
}
