import 'package:c_lup/widgets/CustomBox.dart';
import 'package:c_lup/widgets/LoginCard.dart';
import 'package:c_lup/widgets/MainAppbar.dart';
import 'package:c_lup/widgets/SignUpButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

///Login Page, same for attendant and customer.
class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar(
        title: Text(
          "Login",
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(15.0),
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              child: Image(
                image: AssetImage('assets/images/clup.png'),
                width: 250,
              )),
          Center(child: LoginCard()),
          CustomBox(25, 25),
          SignInButton(
            Buttons.Google,
            onPressed: () {},
          ),
          SignInButton(
            Buttons.Facebook,
            onPressed: () {},
          ),
          Text(
            "Don't have an account?",
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
          SignUpButton()
        ],
      ),
    );
  }
}
