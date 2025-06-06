import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';


class SingUpScreen extends StatefulWidget {
  const SingUpScreen({super.key});

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Criar Conta'),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading) return Center(child: CircularProgressIndicator(),);
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        hintText: 'Nome Completo'
                    ),
                    validator: (text) {
                      if (text!.isEmpty ) return 'nome inválido';
                      return null;
                    },
                  ),
                  SizedBox(height:  16.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: 'E-mail'
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text!.isEmpty || !text.contains('@')) return 'email inválido' ;
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
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                        hintText: 'Endereco'
                    ),
                    validator: (text) {
                      if (text!.isEmpty) return 'endereco inválida';
                      return null;
                    },
                  ),
                  SizedBox(height: 50.0),
                  SizedBox(
                    height: 44.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor
                      ),
                      child: Text('Criar Conta',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Map<String, dynamic> userData = {
                            'name': _nameController.text,
                            'email': _emailController.text,
                            'address': _addressController.text,
                          };
                          model.singUp(
                            userData: userData,
                            pass: _passController.text,
                            onSuccess: _onSucess,
                            onFail: _onFail,
                          );
                        }
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
    //
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text('Usuário criado com sucesso'),
        backgroundColor: Theme.of(context).primaryColor,
    ));
    Future.delayed(Duration(seconds: 5)).then((_) {
        Navigator.of(context).pop();
    });
  }
  void _onFail() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text("Falha ao criar usuário"),
        backgroundColor: Colors.redAccent,
    ));
  }
}



