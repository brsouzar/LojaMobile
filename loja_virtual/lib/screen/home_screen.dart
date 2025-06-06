import 'package:flutter/material.dart';
import 'package:loja_virtual/widgets/card_button.dart';

import '../tabs/home_tab.dart';
import '../tabs/orders_tab.dart';
import '../tabs/products_tab.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});

  final PageController _pageController = PageController();


  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
           Scaffold(
             body: HomeTab(),
             drawer: CustomDrawer(_pageController),
             floatingActionButton: CardButton(),
           ),
           Scaffold(
             appBar: AppBar(
               title: Text('Produtos'),
               centerTitle: true,
             ),
             drawer  : CustomDrawer(_pageController),
             floatingActionButton: CardButton(),
             body: ProductsTab(),
           ),
          Container(color: Colors.yellow,),
         Scaffold(
           appBar: AppBar(
             title: Text('Pedidos'),
             centerTitle: true,
           ),
           body: OrdersTab(),
           drawer: CustomDrawer(_pageController),
         )
      ],
    );
  }
}
    