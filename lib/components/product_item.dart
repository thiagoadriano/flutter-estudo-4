import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/routes.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  void navigatorDetail(context, product) {
    Navigator.of(context).pushNamed(Routes.PRODUCT_DETAIL, arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of(context, listen: false);
    final Cart cart = Provider.of(context, listen: false);
    final ProductsProvider productsProvider =
        Provider.of(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: GridTile(
        child: GestureDetector(
          onTap: () => navigatorDetail(context, product),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_outline),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toogleFavorite();
                productsProvider.updateFavorite(product);
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(product);
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text.rich(TextSpan(children: [
                    TextSpan(text: 'Produto '),
                    TextSpan(
                      text: product.title,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' Adicionado ao Carrinho.')
                  ])),
                  duration: Duration(seconds: 3),
                  action: SnackBarAction(
                    label: 'DESFAZER',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
