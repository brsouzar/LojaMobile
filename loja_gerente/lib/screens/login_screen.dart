import 'package:flutter/material.dart';
import 'package:loja_gerente/blocs/login_bloc.dart';

import '../widget/input_field.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();
    _loginBloc.outState.listen((state) {
      switch(state) {
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context)=> HomeScreen())
          );
          break;
        case LoginState.FAIL:
           showDialog(
               builder: (context)=>AlertDialog(
                title: Text('Error'),
                content: Text('Você não possui os privilégios nescessários'),
               ),
               context: context
           );
           break;
        case LoginState.LOADING:
        case LoginState.IDLE:
      }
    });
  }


  @override
  void dispose() {
   _loginBloc.dispose();
   super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: StreamBuilder<LoginState>(
        stream: _loginBloc.outState,
        initialData: LoginState.LOADING,
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case LoginState.LOADING!:
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                ),
              );
            case LoginState.FAIL:
            case LoginState.SUCCESS:
            case LoginState.IDLE:
              return Stack(
                  alignment: Alignment.center,
                  children: [ Container(),
                    SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.all(16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Icon(
                                Icons.store_mall_directory,
                                color: Colors.pinkAccent,
                                size: 160,
                              ),
                              InputField(
                                icon: Icons.person_outline,
                                hint: 'Usuário',
                                obscure: false,
                                stream: _loginBloc.outEmail,
                                onChanged: _loginBloc.changeEmail,
                              ),
                              InputField(
                                icon: Icons.lock_outline,
                                hint: 'Senha',
                                obscure: true,
                                stream: _loginBloc.outPassword,
                                onChanged: _loginBloc.changePassword,
                              ),
                              SizedBox(height: 25,),
                              StreamBuilder<bool>(
                                  stream: _loginBloc.outSubmitValid,
                                  builder: (context, snapshot) {
                                    return SizedBox(
                                      height: 45,
                                      child: ElevatedButton(
                                        onPressed: snapshot.hasData
                                            ? _loginBloc.submit : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.pinkAccent,
                                          foregroundColor: Colors.white,
                                          disabledBackgroundColor: Colors
                                              .pinkAccent.withAlpha(140),
                                          elevation: 5,
                                        ),
                                        child: Text('Entrar'),
                                      ),
                                    );
                                  }
                              ),
                            ]
                        ),

                      ),
                    ),
                  ]
              );
          }
         }

      ),
    );
  }
}
