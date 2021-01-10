import 'package:c_lup/widgets/EmailField.dart';
import 'package:c_lup/widgets/PasswordField.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpCard extends StatefulWidget {
  SignUpCard({
    Key key,
  }) : super(key: key);

  @override
  _SignUpCardState createState() => _SignUpCardState();
}

class _SignUpCardState extends State<SignUpCard> {
  bool attendant = false;
  bool value = false;

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
                  ListTile(
                    title: Text("Customer", style: Theme.of(context).textTheme.bodyText1,),
                    leading: Radio(
                      value: false,
                      groupValue: attendant,
                      onChanged: (value){
                        setState(() {
                          attendant = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text("Store Attendant", style: Theme.of(context).textTheme.bodyText1,),
                    leading: Radio(
                      value: true,
                      groupValue: attendant,
                      onChanged: (value){
                        setState(() {
                          attendant = value;
                        });
                      },
                    ),
                  ),
                  // DropdownButton<String>(
                  //   isExpanded: true,
                  //   value: _dropdownValue,
                  //   iconSize: 50,
                  //   elevation: 16,
                  //   onChanged: (String newValue) {
                  //     setState(() {
                  //       _dropdownValue = newValue;
                  //       if (newValue == 'Store Attendant') {
                  //         attendant = true;
                  //         print(attendant);
                  //       } else {
                  //         attendant = false;
                  //         print(attendant);
                  //       }
                  //     });
                  //   },
                  //   items: <String>['Customer', 'Store Attendant']
                  //       .map<DropdownMenuItem<String>>((String value) {
                  //     return DropdownMenuItem<String>(
                  //       value: value,
                  //       child: Text(value),
                  //     );
                  //   }).toList(),
                  // ),
                  (attendant == true)
                      ? TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Store ID mustn't be null";
                            } else
                              return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            focusColor: Theme.of(context).accentColor,
                            prefixIcon: Icon(Icons.local_grocery_store),
                            hintText: "Store ID",
                            hintStyle: Theme.of(context).textTheme.bodyText1,
                          ))
                      : Container(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: value,
                        onChanged: (bool value) {
                          setState(() {
                            this.value = value;
                          });
                        },
                      ),
                      Expanded(
                          child: RichText(
                        text: TextSpan(
                          text: 'I have read and agree the ',
                          style: Theme.of(context).textTheme.bodyText2,
                          children: <TextSpan>[
                            TextSpan(
                                text: 'privacy policy',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    var url =
                                        "https://www.clup.it/privacy-policy";
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      print('Could not launch $url');
                                    }
                                  }),
                            TextSpan(text: ', '),
                            TextSpan(
                                text: 'terms & conditions',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    var url =
                                        "https://www.clup.it/terms-and-conditions";
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  }),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      )),
                    ],
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    onPressed: () {
                      // Validate returns true if the form is valid, otherwise false.
                      if (_formKey.currentState.validate() && this.value) {
                        Navigator.pushNamed(context, "/home");
                      }
                    },
                    child: Text(
                      'SIGNUP',
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
