import 'package:flutter/material.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({Key key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                focusColor: Theme.of(context).accentColor,
                prefixIcon: Icon(Icons.person),
                hintText: "Email",
                hintStyle: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                hintText: "Password",
                hintStyle: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            SizedBox(
              height: 1.0,
            ),
            FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, "/forgot");
              },
              child: Text(
                'Forgot your password?',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              onPressed: () {},
              child: Text(
                'LOGIN',
                style: Theme.of(context).textTheme.button,
              ),
            )
          ],
        ),
      ),
    );
  }
}
