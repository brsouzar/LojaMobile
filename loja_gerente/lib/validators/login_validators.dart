import 'dart:async';

class LoginValidators {
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      if (email.contains('@')) {
        sink.add(email);
      }
      else {
        sink.addError('email inválido');
      }
    }
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
        if (password.length > 4) {
          sink.add(password);
        }
        else {
          sink.addError('senha invalida');
        }
      }
  );
}