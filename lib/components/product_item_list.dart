import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/routes.dart';
import 'package:shop/services/request_products.dart';

class ProductItemList extends StatelessWidget {
  final Product product;

  ProductItemList(this.product);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageUrl),
        ),
        title: Text(product.title),
        subtitle: Text(product.price.toStringAsFixed(2)),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(Routes.PRODUCTS_ADM_FORM, arguments: product);
                },
                color: Colors.yellow[800],
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text('Tem ceteza que deseja excluir?'),
                        actions: [
                          FlatButton(
                            child: Text('Nao'),
                            onPressed: ()  => Navigator.of(ctx).pop(false),
                          ),
                          FlatButton(
                            child: Text('Sim'),
                            onPressed: () =>  Navigator.of(ctx).pop(true),
                          )
                        ],
                      );
                    },
                  ).then((isExec) async {
                    if(isExec) {
                      Provider.of<ProductsProvider>(context, listen: false).removeItem(product);
                    }
                  });
                },
                color: Theme.of(context).errorColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
