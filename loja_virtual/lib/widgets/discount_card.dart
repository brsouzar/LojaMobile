import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/card_model.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
          title: Text(
            'Cupom de desconto',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
            ),
          ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: [
          Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Digite seu cumpom aqui'
                ),
                initialValue: CardModel.of(context).coupomCode ?? '',
                onFieldSubmitted: (text) {
                  FirebaseFirestore.instance.collection('coupons').doc(text).get().then(
                      (docSnap) {
                        if (docSnap.data() != null) {
                          Map<String, dynamic> dataResult = docSnap.data() as Map<String, dynamic>;
                          CardModel.of(context).setCoupon(text, dataResult['percent']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Desconto de ${dataResult['percent']}% aplicado'),
                              backgroundColor: Theme.of(context).primaryColor,
                            )
                          );
                        }
                        else {
                          CardModel.of(context).setCoupon(null, 0);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Cupom não existente'),
                                backgroundColor: Colors.redAccent,
                                duration: Duration(seconds: 5),
                              )
                          );
                        }
                      }
                  );
                },
              ),
          ),
        ],
      ),
    );
  }
}
