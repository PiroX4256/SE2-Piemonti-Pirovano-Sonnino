import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmailField extends StatefulWidget{
  EmailField({this.controller});
  final TextEditingController controller;
  @override
  _EmailFieldState createState() => _EmailFieldState();

  }
class _EmailFieldState extends State<EmailField> {
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      controller: widget.controller,
      validator: (value) {
        if (value.isEmpty) {
          return "Email mustn't be null";
        } else if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(value)) {
          return "Please enter a valid email format";
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        focusColor: Theme.of(context).accentColor,
        prefixIcon: Icon(Icons.person),
        hintText: "Email",
        hintStyle: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}