import 'package:c_lup/widgets/EmailField.dart';
import 'package:c_lup/widgets/PasswordField.dart';
import 'package:flutter/material.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Card(
      elevation: 8.0,
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: [
                 EmailField(),
                  SizedBox(
                    height: 15.0,
                  ),
                  PasswordField(),
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
                    onPressed: () {
                      // Validate returns true if the form is valid, otherwise false.
                      if (_formKey.currentState.validate()) {
                        Navigator.pushNamed(context, "/home");
                      }
                    },
                    child: Text(
                      'LOGIN',
                      style: Theme.of(context).textTheme.button,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
