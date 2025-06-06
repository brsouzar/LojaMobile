import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widget/order_header.dart';

class OrderTile extends StatelessWidget {
   OrderTile(this.data, {super.key});

  final DocumentSnapshot data;

  final state = [
    '', 'Em preparação', 'Em Transporte', 'Aguardando Entrega', 'Entregue'
  ];

  @override
  Widget build(BuildContext context) {
    final id = data.id;
    final order = data.data()! as Map<String, dynamic>;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Card(
        child: ExpansionTile(
            key: Key(id),
            initiallyExpanded: order['status'] != 4,
            title: Text('#${id.substring(id.length-7, id.length)}- '
                   '${state[order['status']]}',
              style: TextStyle(color: order['status'] != 4 ? Colors.grey[850] : Colors.green),),
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OrderHeader(order),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: order['products'].map<Widget>((p) {
                          return ListTile(
                            title: Text(p['product']['title'] + ' ' + p['size']),
                            subtitle: Text(p['category']+'/'+p['pid']),
                            trailing: Text(
                              p['quantity'].toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                            contentPadding: EdgeInsets.zero,
                          );
                        }).toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                FirebaseFirestore.instance.collection('users')
                                .doc(order['clienteId']).collection('orders').doc(data.id).delete();
                                data.reference.delete();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: Text('Excluir')
                          ),
                          TextButton(
                              onPressed:order['status'] > 1 ? () {
                                  data.reference.update({'status': order['status'] - 1 });
                              } : null,
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey[850],
                              ),
                              child: Text('Regredir')
                          ),
                          TextButton(
                              onPressed: order['status'] < 4 ? () {
                                data.reference.update({'status': order['status'] + 1});
                              } : null,
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.green,
                              ),
                              child: Text('Avançar')
                          ),
                        ],
                      ),
                    ],
                  ),
              ),
            ],
        ),
      ),
    );
  }
}
