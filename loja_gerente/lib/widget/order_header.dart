import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loja_gerente/blocs/user_bloc.dart';

class OrderHeader extends StatelessWidget {
  const OrderHeader(this.data, {super.key});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.of<UserBloc>(context);
    final _user = _userBloc.getUser(data['clienteId']);

    return Row(
      children: [
        Expanded(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${_user['name']}'),
                Text('${_user['address']}'),
              ],
            ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Produtos: R\$ ${data['productsPrice'].toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w500),),
            Text('Total: R\$ ${data['totalPrice'].toStringAsFixed(2)}',  style: TextStyle(fontWeight: FontWeight.w500),),
          ],
        ),
      ],
    );
  }
}
