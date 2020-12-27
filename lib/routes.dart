import 'package:flutter/material.dart';
import 'package:shop/views/auth_home_view.dart';
import 'package:shop/views/auth_view.dart';
import 'package:shop/views/cart_view.dart';
import 'package:shop/views/orders_view.dart';
import 'package:shop/views/product_adm_form_view.dart';
import 'package:shop/views/products_adm_view.dart';
import 'package:shop/views/products_view.dart';

import 'views/produtc_detail_view.dart';

class Routes {
  static const PRODUCT_DETAIL = '/product-detail';
  static const CART = '/cart';
  static const AUTH_HOME = '/';
  static const ORDERS = '/orders';
  static const PRODUCTS_ADM = '/products-adm';
  static const PRODUCTS_ADM_FORM = '/products-adm-form';
  static const PRODUCTS = '/products';

  static Route<AuthView> unknownRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(builder: (ctx) => AuthOrHomeView());
  }


  static Map<String, Widget Function(BuildContext)> configuration() {
    return {
      AUTH_HOME: (BuildContext ctx) => AuthOrHomeView(),
      PRODUCT_DETAIL: (BuildContext ctx) => ProductDetailView(),
      CART: (BuildContext ctx) => CartView(),
      ORDERS: (BuildContext ctx) => OrdersView(),
      PRODUCTS_ADM: (BuildContext ctx) => ProductsAdmView(),
      PRODUCTS_ADM_FORM: (BuildContext ctx) => ProductsAdmFormView(),
      PRODUCTS: (BuildContext ctx) => ProductsView(),
    };
  }
}