import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  const OrderTile(this.orderId, {super.key});

  final String orderId;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('orders')
                 .doc(orderId).snapshots(),
          builder: (context, snapShot) {
            if (!snapShot.hasData) {
              return Center(child: CircularProgressIndicator(),);
            }
            else {
              Map<String, dynamic> data = snapShot.data!.data() as Map<String, dynamic>;
              int status = data['status'];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Codigo do Pedido: ${snapShot.data!.id}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0,),
                    Text(
                      _buildProdctsText(snapShot.data!)
                    ),
                    SizedBox(height: 4.0,),
                    Text('Status do Pedido',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCircle('1', 'Preparação', status, 1),
                        Container(
                          height: 1.0,
                          width: 40.0,
                          color: Colors.grey.shade500,
                        ),
                        _buildCircle('2', 'Transporte', status, 2),
                        Container(
                          height: 1.0,
                          width: 40.0,
                          color: Colors.grey.shade500,
                        ),
                        _buildCircle('3', 'Entrega', status, 3),
                      ],
                    )
                  ],
                ),
              );
            }
          }
      ),
    );
  }
  String _buildProdctsText(DocumentSnapshot doc) {
    String text = 'Descrição:\n';
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    for(LinkedHashMap p in data['products']) {
        text+= '${p['quantity']} x ${p['product']['title']} (R\$ ${p['product']['price'].toString()})\n';
    }
    text += 'Entrega: R\$ ${data['shipPrice'].toString()}\n';
    text += 'Total: R\$ ${data['totalPrice'].toString()}';
    return text;
  }

  Widget _buildCircle(String title, String subTitle, int status, int thisStatus) {
     Color backColor;
     Widget child;

     if (status < thisStatus) {
       backColor = Colors.grey.shade500;
       child = Text(title, style: TextStyle(color: Colors.white),);
     }
     else if (status == thisStatus) {
       backColor = Colors.blue;
       child = Stack(
         alignment: Alignment.center,
         children: [
           Text(title, style: TextStyle(color:  Colors.white),),
           CircularProgressIndicator(
             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
           ),
         ],
       );
     }
     else {
       backColor = Colors.green;
       child = Icon(Icons.check, color: Colors.white);
     }

     return Column(
       children: [
         CircleAvatar(
            radius: 20.0,
             backgroundColor: backColor,
             child: child,
         ),
         Text(subTitle),
       ],
     );
  }
}
