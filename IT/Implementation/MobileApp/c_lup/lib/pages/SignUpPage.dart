import 'package:c_lup/widgets/MainAppbar.dart';
import 'package:c_lup/widgets/SignUpCard.dart';
import 'package:flutter/material.dart';

///Page used for create an attendant or customer account using email and
///password.
class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar(
        title: Text(
          "Sign Up",
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
      ),
      body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[SignUpCard()]),
    );
  }
}
