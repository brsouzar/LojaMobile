import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';

import '../datas/cart_product.dart';
import '../models/card_model.dart';


class CardTile extends StatelessWidget {
  const CardTile(this.cardProduct, {super.key});

  final CardProduct cardProduct;

  @override
  Widget build(BuildContext context) {
    Widget _buildContext() {
      CardModel.of(context).updatePrice();
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
                cardProduct.productdata!.images![0]
            ),
          ),
          Expanded(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(cardProduct.productdata!.title!,
                      style: TextStyle(color:Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text('Tamanho: ${cardProduct.size}',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    Text('R\$ ${cardProduct.productdata!.price!.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         IconButton(
                             onPressed:cardProduct.quantity! > 1 ? () {
                               CardModel.of(context).decProduct(cardProduct);

                             } : null,
                             icon: Icon(Icons.remove),
                             color: Theme.of(context).primaryColor,
                         ),
                         Text(cardProduct.quantity!.toString()),
                         IconButton(
                             onPressed: () {
                               CardModel.of(context).incProduct(cardProduct);
                             },
                             icon: Icon(Icons.add),
                             color: Theme.of(context).primaryColor,
                         ),
                         TextButton(
                             onPressed: () {
                               CardModel.of(context).removeCardItem(cardProduct);
                             },
                             style: ButtonStyle(
                               foregroundColor : MaterialStateProperty.all<Color>(Colors.grey.shade600),
                             ),
                             child: Text('Remover'),
                         ),
                       ],
                    ),
                  ],
                ),
              ),
          ),
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: cardProduct.productdata == null ?
        FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                  .collection('products')
                  .doc(cardProduct.category)
                  .collection('items').doc(cardProduct.pid).get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final result = snapshot.data!.data()! as Map<String, dynamic>;
                cardProduct.productdata = ProductData.fromJson(result);
                return _buildContext();
              }
              else {
                return Container(
                   height: 70.0,
                  child: CircularProgressIndicator(),
                  alignment: Alignment.center,
                );
              }
            }
       ) : _buildContext()
    );
  }
}
