import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../tiles/category_tile.dart';

class ProductsTab extends StatefulWidget {
  const ProductsTab({super.key});

  @override
  State<ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('products').get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),),);
            }
           return ListView.builder(
             itemCount: snapshot.data!.docs.length,
             itemBuilder: (context, index) {
               return CategoryTile(snapshot.data!.docs[index]);
             },
           );
          }
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
