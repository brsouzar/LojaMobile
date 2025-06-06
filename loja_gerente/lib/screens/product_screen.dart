import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../blocs/product_bloc.dart';
import '../widget/images_widget.dart';
class ProductScreen extends StatefulWidget {
  const ProductScreen(this.categoryId, this.product, {super.key});

  final String categoryId;
  final DocumentSnapshot? product;

  @override
  State<ProductScreen> createState() => _ProductScreenState(categoryId, product);
}

class _ProductScreenState extends State<ProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductBloc _productBloc;

  _ProductScreenState(String categoryId, DocumentSnapshot? product) :
  _productBloc = ProductBloc(categoryId, product) ;

  final fieldStyle = TextStyle(color: Colors.white, fontSize: 16);

  InputDecoration fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[350]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text('Cadastro de Produtos'),
        centerTitle: true,
        elevation: 0,
        actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.remove)),
            IconButton(onPressed: () {}, icon: Icon(Icons.save))
        ],
      ),
      body: Form(
        key: _formKey,
          child: StreamBuilder<Map>(
            stream: _productBloc.outData,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Text(
                    'Imagens',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  ImagesWidget(
                    context: context,
                    initialValue: snapshot.data!['images'],
                    onSaved: (l) {},
                    validator: (l) {},
                  ),
                  TextFormField(
                    initialValue: snapshot.data!['title'],
                    style: fieldStyle,
                    decoration: fieldDecoration('Titulo'),
                    onSaved: (t) {
              
                    },
                    validator: (t) {},
                  ),
                  TextFormField(
                    initialValue: snapshot.data!['description'],
                    style: fieldStyle,
                    maxLines: 6,
                    decoration: fieldDecoration('Descrição'),
                    onSaved: (t) {
              
                    },
                    validator: (t) {},
                  ),
                  TextFormField(
                    initialValue: snapshot.data?['price']?.toStringAsFixed(2),
                    style: fieldStyle,
                    decoration: fieldDecoration('Preço'),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onSaved: (t) {},
                    validator: (t) {},
                  )
                ],
              );
            }
          )
      ),
    );
  }
}
