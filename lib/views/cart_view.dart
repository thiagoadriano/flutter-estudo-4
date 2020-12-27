import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/iterm_cart_component.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';

class CartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    final items = cart.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Carrinho"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(25),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 10),
                  Chip(
                    label: Text(
                      'R\$ ${cart.totalAmount}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  OrderPayment(items: items, cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, i) => ItermCartComponent(items[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderPayment extends StatefulWidget {
  const OrderPayment({
    Key key,
    @required this.items,
    @required this.cart,
  }) : super(key: key);

  final List<CartItem> items;
  final Cart cart;

  @override
  _OrderPaymentState createState() => _OrderPaymentState();
}

class _OrderPaymentState extends State<OrderPayment> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: widget.cart.itemCount == 0 ? null : () async {
        setState((){_isLoading = true;});
        await Provider.of<Orders>(context, listen: false).addOrder(widget.items);
        setState((){_isLoading = false;});
        widget.cart.clear();
      },
      child: _isLoading ? CircularProgressIndicator() : Text(
        'COMPRAR',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
