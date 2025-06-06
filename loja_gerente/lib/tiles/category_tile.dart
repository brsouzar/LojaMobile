import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/product_screen.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile(this.category, {super.key});

  final DocumentSnapshot category;


  @override
  Widget build(BuildContext context) {
    final _categoryData = category.data()! as Map<String, dynamic>;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child:
        ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(_categoryData['icon']),
            ) ,
            title: Text(
                _categoryData['title'],
                style: TextStyle(color: Colors.grey[850], fontWeight: FontWeight.w500),
            ),
          children: [
            FutureBuilder<QuerySnapshot>(
                future: category.reference.collection('items').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: snapshot.data!.docs.map((doc) {
                          final docData = doc.data()! as Map<String, dynamic>;
                          return ListTile(
                             leading: CircleAvatar(
                               backgroundImage: NetworkImage(docData['images'][0]),
                               backgroundColor: Colors.transparent,
                             ),
                             title: Text(docData['title']),
                             trailing: Text('R\$ ${docData['price'].toStringAsFixed(2)}'),
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context)=> ProductScreen(
                                     category.id, doc
                                  )),
                              );
                            },
                          );
                      }).toList()..add(
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.add, color: Colors.pinkAccent,),
                          ),
                          title: Text('Adicionar'),
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context)=> ProductScreen(category.id, null))
                            );
                          },
                        )
                      ),
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
