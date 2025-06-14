import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen(this.orderId, {super.key});

  final String? orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido Realizado',),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Column(
          children: [
            Icon(Icons.check, color: Theme.of(context).primaryColor, size: 80.0,),
            Text('Pedido Realizado com sucesso', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
            Text('Codigo do pedido', style: TextStyle(fontSize: 16.0),),
          ],
        ),
      ),
    );
  }
}
