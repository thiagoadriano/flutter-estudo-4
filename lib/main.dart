import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/custom_route.dart';
import 'package:shop/providers/auth_provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (_) => ProductsProvider(), 
          update: (ctx, auth, prevProducts) => ProductsProvider(auth.token, auth.userId)
        ),
        ChangeNotifierProxyProvider<AuthProvider, Orders>(
          create: (_) => Orders(),
          update: (_, auth, prevOrders) => Orders(auth.token, auth.userId)
        ),
        ChangeNotifierProvider(create: (_) => Cart()),
      ],
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CustomPageTransitions(),
            TargetPlatform.iOS: CustomPageTransitions(),
          })
        ),
        onUnknownRoute: Routes.unknownRoute,
        routes: Routes.configuration(),
      ),
    );
  }
}
