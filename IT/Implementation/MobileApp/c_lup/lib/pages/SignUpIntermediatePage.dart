import 'package:c_lup/widgets/MainAppbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class SignUpIntermediatePage extends StatefulWidget {
  SignUpIntermediatePage({Key key}) : super(key: key);

  @override
  _SignUpIntermediatePageState createState() => _SignUpIntermediatePageState();
}

class _SignUpIntermediatePageState extends State<SignUpIntermediatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar(),
      body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage('assets/images/clup.png'),
                  width: 400,
                )),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/sign-up");
              },
              child: Text(
                'REGISTER WITH EMAIL',
                style: Theme.of(context).textTheme.button,
              ),
            ),
            SizedBox(
              height: 6.0,
            ),
            SignInButton(
              Buttons.Google,
              text: "Sign up with Google",
              onPressed: () {},
            ),
            SizedBox(
              height: 6.0,
            ),
            SignInButton(
              Buttons.Facebook,
              text: "Sign up with Facebook",
              onPressed: () {},
            ),
          ]),

    );
  }
}
