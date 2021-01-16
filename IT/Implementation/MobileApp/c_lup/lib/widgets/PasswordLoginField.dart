import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordLoginField extends StatefulWidget {
  PasswordLoginField({this.controller});
  @override
  _PasswordLoginFieldState createState() => _PasswordLoginFieldState();
  final TextEditingController controller;
}

class _PasswordLoginFieldState extends State<PasswordLoginField> {
  bool _isHidden = true;
  Icon _visibility = Icon(Icons.visibility_off);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: (value) {
        if (value.isEmpty) {
          return "Password cannot be null";
        }
        else
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
