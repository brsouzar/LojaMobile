import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/card_model.dart';

class CardPrice extends StatelessWidget {
  const CardPrice(this.buy, {super.key});

  final VoidCallback buy;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: ScopedModelDescendant<CardModel>(
            builder: (context, child, model) {
              double price = model.getProductPrice();
              double discount = model.getDiscount();
              double ship = model.getShipPrice();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    Text('Resumo do Pedido',
                        style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  SizedBox(height: 12.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text('Subtotal'),
                       Text('R\$ ${price.toStringAsFixed(2)}')
                     ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Desconto'),
                      Text('R\$ ${discount.toStringAsFixed(2)}')
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Entrega'),
                      Text('R\$ ${ship.toStringAsFixed(2)}')
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 12.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: TextStyle(fontWeight: FontWeight.w500),),
                      Text('R\$ ${(price + ship - discount).toStringAsFixed(2)}',
                        style: TextStyle( color: Theme.of(context).primaryColor, fontSize: 16.0),),
                    ],
                  ),
                  SizedBox(height: 12.0,),
                  ElevatedButton(
                    onPressed: buy,
                    style:  ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            ),
                            textStyle: TextStyle(color: Colors.white),
                            ),
                     child: Text('Finalizar pedido', style: TextStyle(color: Colors.white),),
                  ),
                ],
              );
            }
        ),
      ),
    );
  }
}
