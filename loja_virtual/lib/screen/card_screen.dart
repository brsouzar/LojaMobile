import 'package:flutter/material.dart';
import 'package:loja_virtual/models/card_model.dart';
import 'package:loja_virtual/screen/login_screen.dart';
import 'package:loja_virtual/screen/order_screen.dart';
import 'package:loja_virtual/widgets/card_price.dart';
import 'package:loja_virtual/widgets/discount_card.dart';
import 'package:loja_virtual/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/user_model.dart';
import '../tiles/card_tile.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Carrinho'),
        centerTitle: true,
        actions: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8.0),
            child: ScopedModelDescendant<CardModel>(
                builder: (context, child, model) {
                  int p = model.products.length;
                  return Text(
                     '${p ?? 0} ${p == 1 ? 'ITEM' : 'ITENS'}',
                    style: TextStyle(fontSize: 17.0),
                  );
                }
            ),
          ),
        ],
      ),
      body: ScopedModelDescendant<CardModel>(
        builder: (context, child, model) {
          if (model.isLoading && UserModel.of(context).isLoggedIn()) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!UserModel.of(context).isLoggedIn()) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove_shopping_cart, size: 80.0, color: Theme.of(context).primaryColor,),
                  SizedBox(height: 16.0,),
                  Text('Faça o login para adicionar produtos!',
                      style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0,),
                  ElevatedButton(
                    onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>LoginScreen())
                        );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor :Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      textStyle: TextStyle(color: Colors.white),
                    ),
                    child: Text('Entrar', 
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                  ),
                ],
              ),
            );
          }
          else if (model.products.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Nenhum produto no carrinho',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }
          else {
            return ListView(
              children: [
                Column(
                  children: model.products.map(
                      (product) {
                        return CardTile(product);
                      }
                  ).toList()
                ),
                DiscountCard(),
                ShipCard(),
                CardPrice(() async {
                  String? orderId = await model.finishOrder();
                  if (orderId != null) {
                    MaterialPageRoute(builder: (context)=> OrderScreen(orderId));
                  }
                }),
              ],
            );
          }

        },
      ),
    );
  }
}
