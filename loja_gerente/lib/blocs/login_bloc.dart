import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loja_gerente/validators/login_validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum LoginState {IDLE, LOADING, SUCCESS, FAIL }

class LoginBloc extends BlocObserver implements LoginValidators {

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();

  final singOut = FirebaseAuth.instance.signOut();
  StreamSubscription? _streamSubscription;

  LoginBloc() {
    _streamSubscription = FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        if (await verifyPrivileges(user)) {
          _stateController.add(LoginState.SUCCESS);
        }
        else {
          singOut;
          _stateController.add(LoginState.FAIL);
        }
      }
      else {
        _stateController.add(LoginState.IDLE);
      }
    });
  }

  Stream<String> get outEmail => _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword => _passwordController.stream.transform(validatePassword);
  Stream<LoginState> get outState => _stateController.stream;

  Stream<bool> get outSubmitValid => Rx.combineLatest2(
     outEmail, outPassword, (a,b) => true
  );

   Function(String) get changeEmail => _emailController.sink.add;
   Function(String) get changePassword => _passwordController.sink.add;

  void submit() {
     final email = _emailController.value;
     final password = _passwordController.value;

     FirebaseAuth.instance.signInWithEmailAndPassword(
         email: email,
         password: password
     ).catchError((e) {
          _stateController.add(LoginState.FAIL);
     });
   }
   
   Future<bool> verifyPrivileges(User user) async {
     return await FirebaseFirestore.instance.collection('admin').doc(user.uid)
          .get().then(
          (doc) {
            if (doc.data() != null) {
              return true;
            }
            else {
              return false;
            }
          }
      ).catchError((e)=> false);
   }


  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _stateController.close();
    _streamSubscription!.cancel();
  }

  @override
  // TODO: implement validateEmail
  StreamTransformer<String, String> get validateEmail => LoginValidators().validateEmail;

  @override
  // TODO: implement validatePassword
  StreamTransformer<String, String> get validatePassword => LoginValidators().validatePassword;

}