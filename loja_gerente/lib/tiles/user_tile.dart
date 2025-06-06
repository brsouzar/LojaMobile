import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserTile extends StatelessWidget {
   UserTile(this.user, {super.key});

  final Map<String, dynamic> user;

  final colorStyle = TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    if (user.containsKey('money')) {
      return ListTile(
        title: Text(
          user['name'],
          style: colorStyle,
        ),
        subtitle: Text(
          user['email'],
          style: colorStyle,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pedidos: ${user['orders']}', style: colorStyle,),
            SizedBox(height: 7,),
            Text('Gasto: R\$${user['money'].toStringAsFixed(2)}', style: colorStyle,),
          ],
        ),
      );
    }
    else {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 200,
              height: 20,
              child: Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Colors.grey,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    color: Colors.white.withAlpha(50),
                  )
              ),
            ),
            SizedBox(
              width: 50,
              height: 20,
              child: Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Colors.grey,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    color: Colors.white.withAlpha(50),
                  )
              ),
            ),
          ],
        )
      );
    }

  }
}
