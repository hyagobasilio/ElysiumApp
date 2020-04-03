import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class InputField extends StatelessWidget {
  final String hint;
  final bool obscure;
  final Stream stream;
  final Function(String) onChange;
  final TextEditingController controller;

  InputField({this.hint, this.obscure, this.stream, this.onChange, this.controller});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot){
        return TextField(
          controller: controller,
          onChanged: onChange,
          obscureText:  obscure,
          style: TextStyle(fontSize: 20.0),
          decoration: InputDecoration(
              errorText: snapshot.hasError ? snapshot.error : null,
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: hint,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );
      });
  }

}