import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/badge.dart';
import 'package:shop/components/menu.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/routes.dart';

enum FilterOptions { Favorite, All }

class ProductsView extends StatefulWidget {
  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  bool _showFavoriteOnly = false;

  Future<void> _refreshProducts(context) {
    Provider.of<ProductsProvider>(context, listen: false).getItems();
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions selected) {
              setState(() {
                _showFavoriteOnly = selected == FilterOptions.Favorite;
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favoritos'),
                value: FilterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text('Todos'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.CART);
              },
            ),
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
          ),
        ],
      ),
      drawer: Menu(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Provider.of<ProductsProvider>(context).inLoadingItens ? 
        Center(child: CircularProgressIndicator()) :
        ProductGrid(_showFavoriteOnly)
      ),
    );
  }
}
