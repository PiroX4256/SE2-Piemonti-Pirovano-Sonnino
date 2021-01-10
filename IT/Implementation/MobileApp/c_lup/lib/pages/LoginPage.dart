import 'package:c_lup/widgets/LoginCard.dart';
import 'package:c_lup/widgets/MainAppbar.dart';
import 'package:c_lup/widgets/SignUpButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: MainAppbar(title: Text("Login", style: TextStyle(color:Theme.of(context).accentColor),),),
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
          Center(
            child: LoginCard()
          ),
          SizedBox(
            height: 25.0,
          ),
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
