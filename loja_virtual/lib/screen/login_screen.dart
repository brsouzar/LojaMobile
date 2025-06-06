import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screen/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Entrar'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> SingUpScreen()));
            },
            child: Text('CRIAR CONTA',
              style: TextStyle(fontSize: 15.0),
            ),
          ),
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading)  return Center(child: CircularProgressIndicator(),);
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: 'E-mail'
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text!.isEmpty || !text.contains('@')) return 'email inválido';
                      return null;
                    },
                  ),
                  SizedBox(height:  16.0),
                  TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(
                        hintText: 'Senha'
                    ),
                    obscureText: true,
                    validator: (text) {
                      if (text!.isEmpty) return 'senha inválida';
                      return "";
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: TextButton(
                        onPressed: () {
                          if (_emailController.text.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text("Insira seu e-mail para recuperação"),
                              backgroundColor: Colors.redAccent,
                            ));
                          }
                          else {
                            model.recoverPass(_emailController.text);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text("Confira seu email"),
                              backgroundColor: Theme.of(context).primaryColor,
                            ));
                          }
                        },
                        child: Text('Esqueci minha senha',
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(
                    height: 44.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor
                      ),
                      child: Text('Entre',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {

                        }
                        model.singIn(
                            email: _emailController.text,
                            pass: _passController.text,
                            onSuccess: _onSucess,
                            onFail: _onFail
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
  void _onSucess() {
      Navigator.of(context).pop();
  }
  void _onFail() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
      content: Text("Falha ao entrar"),
      backgroundColor: Colors.redAccent,
    ));
  }
}



