import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';

class ItermCartComponent extends StatelessWidget {
  final CartItem _cartitem;

  ItermCartComponent(this._cartitem);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(_cartitem.productId),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4
        ),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Tem Certeza?'),
            content: Text('Que quer remover este item?'),
            actions: [
              FlatButton(
                child: Text('Nao'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                }, 
              ),
              FlatButton(
                child: Text('Sim'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                }, 
              )
            ]
          )
        );
      },
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).removeItem(_cartitem.productId);
        
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(2.5),
                child: FittedBox(
                  child: Text(
                    _cartitem.price.toString(),
                  ),
                ),
              ),
            ),
            title: Text(_cartitem.title),
            subtitle: Text('Total R\$ ${_cartitem.total}'),
            trailing: Text('${_cartitem.quantity}x'),
          ),
        ),
      ),
    );
  }
}
