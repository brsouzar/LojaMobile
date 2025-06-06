import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';
import '../tiles/product_tile.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen(this.data, {super.key});

  final DocumentSnapshot? data;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title:Text(data!['title']),
            centerTitle: true,
            bottom: TabBar(
                indicatorColor: Colors.white,
                tabs: [
                     Tab(icon: Icon(Icons.grid_on),),
                     Tab(icon: Icon(Icons.list),),
                ],
            ),
          ),
          body: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('products')
                  .doc(data!.id).collection('items').get(),
              builder: (context, snapshot) {
                 if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(),);
                 }
                   List<Map<String, dynamic>> documents =
                   snapshot.data!.docs.map((DocumentSnapshot doc) {
                     final data = doc.data()! as Map<String, dynamic>;
                     data['id'] = doc.id;
                     return data;
                   }).toList().cast();

                   return TabBarView(
                       physics: NeverScrollableScrollPhysics(),
                       children: [
                           GridView.builder(
                               padding: EdgeInsets.all(4.0),
                               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                 crossAxisCount:2,
                                 crossAxisSpacing: 1.0,
                                 childAspectRatio: 0.60,
                               ),
                               itemCount: snapshot.data!.docs.length,
                               itemBuilder: (context, index) {
                                 ProductData data = ProductData.fromJson(documents[index]);
                                 data.category = this.data!.id;
                                 return ProductTile('grid', data);
                               }
                           ),
                         ListView.builder(
                             padding: EdgeInsets.all(4.0),
                             itemCount: snapshot.data!.docs.length,
                             itemBuilder: (context, index) {
                               ProductData data = ProductData.fromJson(documents[index]);
                               data.category = this.data!.id;
                               return ProductTile('list',  data) ;
                             }
                         ),
                       ],
                   );

              }
          ),
        ),
    );
  }
}
