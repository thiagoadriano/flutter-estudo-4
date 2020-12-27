import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/providers/orders.dart';

class OrderItemComponent extends StatefulWidget {
  final Order order;

  OrderItemComponent(this.order);

  @override
  _OrderItemComponentState createState() => _OrderItemComponentState();
}

class _OrderItemComponentState extends State<OrderItemComponent> {
  bool _expand = false;

  @override
  Widget build(BuildContext context) {
    final itemHeigth = (widget.order.products.length * 32.0 + 15);
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expand ? itemHeigth + 92 : 92,
      child: Card(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              ListTile(
                title: Text('R\$ ${widget.order.total.toStringAsFixed(2)}'),
                subtitle: Text(
                    DateFormat('dd/MM/yy hh:mm').format(widget.order.date)),
                trailing: IconButton(
                  icon: Icon(!_expand ? Icons.expand_more : Icons.expand_less),
                  onPressed: () {
                    setState(() {
                      _expand = !_expand;
                    });
                  },
                ),
              ),
                AnimatedContainer(
                  height: _expand ? itemHeigth : 0,
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 4,
                  ),
                  child: ListView(
                    children: widget.order.products.map((prod) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                prod.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${prod.quantity}x R\$ ${prod.price}',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[500]),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
            ],
          )),
    );
  }
}
