import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screen/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/card_model.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
        model: UserModel(),
        child: ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              return ScopedModel<CardModel>(
                model: CardModel(model),
                child:  MaterialApp(
                  title: 'BrStore',
                  theme: ThemeData(
                      primarySwatch: Colors.blue,
                      primaryColor: Color.fromARGB(255, 4, 125, 141)
                  ),
                  debugShowCheckedModeBanner: false,
                  home: HomeScreen(),
                ),
              );
            }
        ),
    );
  }

}

