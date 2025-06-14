import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screen/category_screen.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile(this.data, {super.key});

  final DocumentSnapshot data;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(data['icon']),
      ),
      title: Text(data['title']),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>CategoryScreen(data))
          );
      },
    );
  }
}
