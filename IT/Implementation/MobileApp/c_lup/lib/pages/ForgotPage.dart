import 'package:c_lup/widgets/CustomBox.dart';
import 'package:c_lup/widgets/MainAppbar.dart';
import 'package:flutter/material.dart';

///Page for resetting user's password.
class ForgotPage extends StatefulWidget {
  ForgotPage({Key key}) : super(key: key);

  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
        appBar: MainAppbar(
            title: Text('Reset Password',
                style: TextStyle(color: Theme.of(context).accentColor))),
        body: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(15.0),
            children: <Widget>[
              Card(
                elevation: 8.0,
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(children: <Widget>[form(_formKey, context)])),
              )
            ]));
  }

  ///Input form.
  Form form(GlobalKey<FormState> _formKey, BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          Text(
            "Please enter your email address. You will receive a link to create a new password via email. ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff8A888A),
            ),
          ),
          emailFormField(),
          CustomBox(10, 10),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            onPressed: () {
              // Validate returns true if the form is valid, otherwise false.
              if (_formKey.currentState.validate()) {
                return dialog(context);
              }
            },
            child: Text(
              'CONFIRM',
              style: Theme.of(context).textTheme.button,
            ),
          )
        ]));
  }

  ///Dialog.
  Future<void> dialog(BuildContext context) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Email sent',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).accentColor),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      "If your email is in our database, you will shortly receive an email with the instruction for resetting your password.")
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text(
                    'Ok',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/login", (r) => false);
                  })
            ],
          );
        });
  }

  //Email form field.
  TextFormField emailFormField() {
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.email),
        hintText: 'Registered email',
        labelText: 'Email*',
      ),
      onSaved: (String value) {},
      validator: (String value) {
        if (value.isEmpty) {
          return "Email field cannot be empty";
        } else if (!RegExp(
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(value)) {
          return "Please enter a valid email format";
        } else {
          return null;
        }
      },
    );
  }
}
