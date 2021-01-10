import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isHidden = true;
  Icon _visibility = Icon(Icons.visibility_off);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return "Password mustn't be null";
        } else if (!RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
            .hasMatch(value)) {
          return "Password must contain at least:\n• one lower case;\n• one upper case;\n• one digit;\n• one special character (!@#\\\$&*~)."; // should contain at least one Special character";
        } else
          return null;
      },
      obscureText: _isHidden,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        hintText: "Password",
        hintStyle: Theme.of(context).textTheme.bodyText1,
        suffix: InkWell(onTap: _togglePasswordView, child: _visibility),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
      if (_isHidden) {
        _visibility = Icon(Icons.visibility_off);
      } else
        _visibility = Icon(Icons.visibility);
    });
  }
}
