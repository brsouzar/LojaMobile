import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/order_bloc.dart';
import '../tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final _odersBloc = BlocProvider.of<OrderBloc>(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: StreamBuilder<List>(
        initialData: _odersBloc.orderslist,
        stream: _odersBloc.outOders,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),),);
          }
          else if (snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum pedido encontrado...', style: TextStyle(color: Colors.pinkAccent),),);
          }
          else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return OrderTile(snapshot.data![index]);
              },
            );
          }
        }
      ),
    );
  }
}
