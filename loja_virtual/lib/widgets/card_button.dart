import 'package:flutter/material.dart';
import 'package:loja_virtual/screen/card_screen.dart';

class CardButton extends StatelessWidget {
  const CardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
             MaterialPageRoute(builder: (context)=> CardScreen())
          );
        },
        backgroundColor: Theme.of(context).primaryColor ,
        child: Icon(Icons.shopping_cart, color: Colors.white,),
    );
  }
}
