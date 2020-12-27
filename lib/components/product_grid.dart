import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/models/product.dart';
import 'package:shop/providers/products_provider.dart';

class ProductGrid extends StatelessWidget {
  final bool _showFavoriteOnly;

  ProductGrid(this._showFavoriteOnly);

  @override
  Widget build(BuildContext context) {
    final ProductsProvider productsProvider = Provider.of<ProductsProvider>(context);
    final products = _showFavoriteOnly ? productsProvider.itemsFavorite : productsProvider.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (_, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3 / 2,
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
    );
  }
}
