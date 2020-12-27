import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/custom_route.dart';
import 'package:shop/providers/auth_provider.dart';
import 'package:shop/views/orders_view.dart';

import '../routes.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Bem vindo!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Loja'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                Routes.PRODUCTS,
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Pedidos'),
            onTap: () {
              // Navigator.of(context).pushReplacementNamed(
              //   Routes.ORDERS,
              // );
              Navigator.of(context).pushReplacement(
                CustomRoute(builder: (ctx) => OrdersView())
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Gerenciar Produtos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                Routes.PRODUCTS_ADM,
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sair'),
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed(
                Routes.AUTH_HOME,
              );
            },
          ),
        ],
      ),
    );
  }
}
