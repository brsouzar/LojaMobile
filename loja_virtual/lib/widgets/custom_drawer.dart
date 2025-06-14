import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screen/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import '../tiles/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
   const CustomDrawer(this.pageController, {super.key});

   final PageController pageController;

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 203, 236, 241),
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
    return Drawer(
      child: Stack(
        children:[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0),
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding:EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 174.0,
                child: Stack(
                  children: [
                    Positioned(
                        top: 8.0,
                        left: 8.0,
                        child: Text("BrStore's\nClothing",
                                style: TextStyle(
                                  fontSize: 34.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                    Positioned(
                        left: 0.0,
                        bottom: 0.0,
                        child: ScopedModelDescendant<UserModel>(
                            builder: (context, child, model) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text("Olá, ${!model.isLoggedIn() ? " " : model.userData['name']} ",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    GestureDetector(
                                      child: Text(!model.isLoggedIn() ? 'Entre ou cadastre-se >'
                                          : 'Sair',
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      onTap: () {
                                         if (! model.isLoggedIn()) {
                                           Navigator.of(context).push(
                                               MaterialPageRoute(builder: (context)=>LoginScreen())
                                           );
                                         }
                                         else {
                                            model.signOut();
                                         }
                                      },
                                    ),
                                ],
                              );
                            }
                        ),
                    ),
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, 'Início', pageController, 0),
              DrawerTile(Icons.list, 'Produtos', pageController, 1),
              DrawerTile(Icons.location_on, 'Lojas', pageController, 2),
              DrawerTile(Icons.playlist_add_check, 'Meus Pedidos', pageController, 3),
            ],

          ),
        ],
      ),
    );
  }
}
