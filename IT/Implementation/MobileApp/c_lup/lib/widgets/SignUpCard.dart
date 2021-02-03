import 'package:c_lup/utils/AuthService.dart';
import 'package:c_lup/widgets/CustomBox.dart';
import 'package:c_lup/widgets/EmailField.dart';
import 'package:c_lup/widgets/PasswordField.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';

///Sign Up Card.
class SignUpCard extends StatefulWidget {
  SignUpCard({
    Key key,
  }) : super(key: key);

  @override
  _SignUpCardState createState() => _SignUpCardState();
}

class _SignUpCardState extends State<SignUpCard> {
  String storeId;
  bool attendant = false;
  bool value = false;
  String role = "USER";
  Text alertTitle;
  Text alertBody;
  Text alertButtonText;
  bool error;
  TextEditingController controller = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();

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
                  EmailField(
                    controller: controller,
                  ),
                  CustomBox(15, 15),
                  PasswordField(
                    controller: controller2,
                  ),
                  CustomBox(1, 1),
                  ListTile(
                    title: Text(
                      "Customer",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    leading: Radio(
                      value: false,
                      groupValue: attendant,
                      onChanged: (value) {
                        setState(() {
                          attendant = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Store Attendant",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    leading: Radio(
                      value: true,
                      groupValue: attendant,
                      onChanged: (value) {
                        setState(() {
                          attendant = value;
                        });
                      },
                    ),
                  ),
                  (attendant == true)
                      ? TextFormField(
                          controller: controller3,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Store ID field cannot be empty";
                            } else
                              return null;
                          },
                          decoration: InputDecoration(
                            focusColor: Theme.of(context).accentColor,
                            prefixIcon: Icon(Icons.local_grocery_store),
                            hintText: "Store ID*",
                            hintStyle: Theme.of(context).textTheme.bodyText1,
                          ))
                      : Container(),
                  CustomBox(10, 10),
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: value,
                          onChanged: (bool value) {
                            setState(() {
                              this.value = !this.value;
                            });
                          }),
                      Expanded(
                          child: RichText(
                        text: TextSpan(
                          text: 'I have read and agree the ',
                          style: Theme.of(context).textTheme.bodyText2,
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Privacy Policy',
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
                                text: 'Terms & Conditions',
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
                    onPressed: () async {
                      if (_formKey.currentState.validate() && this.value) {
                        EasyLoading.show();
                        if (attendant == true) {
                          role = "ATTENDANT";
                          storeId = controller3.text;
                        }
                        if (await AuthService.signUp(
                            email: controller.text,
                            password: controller2.text,
                            role: role,
                            storeId: storeId)) {
                          EasyLoading.dismiss();
                          setState(() {
                            alertTitle = Text('Registration Completed');
                            alertBody = Text(
                                'The registration was successful, you will shortly receive a email confirming it');
                            error = false;
                            alertButtonText = Text('Home');
                          });
                        } else {
                          EasyLoading.dismiss();
                          setState(() {
                            alertTitle = Text('Error');
                            alertBody =
                                Text('Registration invalid, please retry!');
                            error = true;
                            alertButtonText = Text('Ok');
                          });
                        }
                        signUpDialog(context);
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

  ///Sign up Dialog.
  Future signUpDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: alertTitle,
            content: SingleChildScrollView(
                child: ListBody(children: <Widget>[alertBody])),
            actions: <Widget>[
              TextButton(
                child: alertButtonText,
                onPressed: () {
                  if (error) {
                    Navigator.popAndPushNamed(context, "/sign-up");
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/home", (r) => false);
                  }
                },
              )
            ],
          );
        });
  }
}
