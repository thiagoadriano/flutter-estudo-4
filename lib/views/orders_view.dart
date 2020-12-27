import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/menu.dart';
import 'package:shop/components/order_item_component.dart';
import 'package:shop/providers/orders.dart';

class OrdersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos'),
      ),
      drawer: Menu(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).getOrdens(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Consumer<Orders>(
              builder: (ctx, orders, child) {
                return ListView.builder(
                    itemCount: orders.count,
                    itemBuilder: (ctx, idx) =>
                        OrderItemComponent(orders.orders[idx]));
              },
            );
          }
        },
      ),
    );
  }
}
