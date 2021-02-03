import 'package:flutter/material.dart';

///Sign Up Button.
class SignUpButton extends StatelessWidget {
  const SignUpButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      onPressed: () {
        Navigator.pushNamed(context, "/intermediate");
      },
      child: Text(
        'CREATE A NEW ACCOUNT',
        style: Theme.of(context).textTheme.button,
      ),
    );
  }
}
