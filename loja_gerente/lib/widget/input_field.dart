import 'package:flutter/material.dart';


class InputField extends StatelessWidget {
  const InputField({super.key, required this.icon,
    required this.hint, required this.obscure,required this.stream, required this.onChanged});

  final IconData icon;
  final String hint;
  final bool obscure;
  final Stream<String> stream;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: onChanged,
          decoration: InputDecoration(
            icon: Icon(icon, color: Colors.white,),
            hintText: hint,
            hintStyle:  TextStyle(color: Colors.white),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
            ),
            contentPadding: EdgeInsets.only(
              left: 5,
              right: 30,
              bottom: 20,
              top: 20,
            ),
            errorText: snapshot.hasError ? snapshot.error.toString() : '',
          ),
          style: TextStyle(color: Colors.white),
          obscureText: obscure,
        );
      }
    );
  }
}
