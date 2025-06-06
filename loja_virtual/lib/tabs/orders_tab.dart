import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';

import '../screen/login_screen.dart';
import '../tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
   if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser!.uid;

      return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(uid)
          .collection('orders').get(),
          builder: (context, snapShot) {
                  if (!snapShot.hasData) {
                    return Center(child: CircularProgressIndicator(),);
                  }
                  else {
                    return ListView(
                      children: snapShot.data!.docs.map((doc)=>OrderTile(doc.id)).toList(),
                    );
                  }
          }
      );
   } else {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.view_list, size: 80.0, color: Theme.of(context).primaryColor,),
            SizedBox(height: 16.0,),
            Text('Faça o login para acompanhar',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
  }
}
