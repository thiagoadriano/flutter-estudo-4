import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/menu.dart';
import 'package:shop/components/product_item_list.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/routes.dart';

class ProductsAdmView extends StatelessWidget {
  
  Future<void> _refreshProducts(context) {
    Provider.of<ProductsProvider>(context, listen: false).getItems();
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    final ProductsProvider products = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciamento de Produtos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () {
              Navigator.of(context).pushNamed(
                Routes.PRODUCTS_ADM_FORM
              );
            },
          )
        ],
      ),
      drawer: Menu(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: ListView.builder(
            itemCount: products.count,
            itemBuilder: (ctx, idx) {
              return ProductItemList(products.items[idx]);
            },
          ),
        ),
      ),
    );
  }
}
