import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:loja_gerente/tabs/products_tab.dart';
import 'package:loja_gerente/tabs/users_tab.dart';

import '../blocs/order_bloc.dart';
import '../blocs/user_bloc.dart';
import '../tabs/orders_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController? _pageController;

  int _page = 0;
  UserBloc? _userBloc;
  OrderBloc? _orderBloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _userBloc = UserBloc();
    _orderBloc = OrderBloc();
  }


  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.pinkAccent,
          primaryColor: Colors.white,
        ),
        child: BottomNavigationBar(
          currentIndex: _page,
          onTap: (p) {
             _pageController!.animateToPage(p,
                 duration: Duration(microseconds: 500),
                 curve: Curves.ease
             );
          },
          items: [
            BottomNavigationBarItem(
              label: 'Clientes',
              icon: Icon(Icons.person),
            ),
            BottomNavigationBarItem(
              label: 'Pedidos',
              icon: Icon(Icons.shopping_cart),
            ),
            BottomNavigationBarItem(
              label: 'Produtos',
              icon: Icon(Icons.list),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: BlocProvider<UserBloc>(
          create:(BuildContext context) => _userBloc!,
          child: BlocProvider<OrderBloc>(
            create:(BuildContext context) => _orderBloc!,
            child: PageView(
              controller: _pageController,
              onPageChanged: (p) {
                setState(() {
                  _page = p;
                });
              },
              children: [
                UsersTab(),
                OrdersTab(),
                ProductsTab(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloating()!,
    );
  }

  Widget? _buildFloating() {
    switch (_page) {
      case 0:
      case 2:
        return Container();
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Colors.pinkAccent,
          foregroundColor: Colors.white,
          overlayColor: Colors.grey,
          children: [
            SpeedDialChild(
              child: Icon(Icons.arrow_downward, color: Colors.pinkAccent,),
              backgroundColor: Colors.white,
              label: 'Concluidos abaixo',
              labelStyle: TextStyle(fontSize: 14),
              onTap: () {
                _orderBloc!.setOrderCriteria(SortCriteria.READ_LAST);
              }
            ),
            SpeedDialChild(
                child: Icon(Icons.arrow_upward, color: Colors.pinkAccent,),
                backgroundColor: Colors.white,
                label: 'Concluidos Acima',
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _orderBloc!.setOrderCriteria(SortCriteria.READ_FIRST);
                }
            )
          ],
        );
    }
    return null;
  }
}


