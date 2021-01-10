import 'package:flutter/material.dart';

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
  String dropdownValue = 'Customer';
  TextEditingController controller = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: controller,
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
            Container(
                child: Align(
                  alignment: Alignment.centerLeft,
              child: DropdownButton<String>(
                isExpanded: true,
                value: dropdownValue,
                iconSize: 50,
                elevation: 16,
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                    if (newValue == 'Store Attendant') {
                      attendant = true;
                      print(attendant);
                    } else {
                      attendant = false;
                      print(attendant);
                    }
                  });
                },
                items: <String>['Customer', 'Store Attendant']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            )),
            (attendant == true)
                ? TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.local_grocery_store),
                      hintText: "Store ID",
                      hintStyle: Theme.of(context).textTheme.bodyText2,
                    ))
                : Container(),
            SizedBox(
              height: 10.0,
            ),
            CheckboxListTile(
              title: RichText(
                text: TextSpan(
                  text: 'I have read and agree the ',
                  style: Theme.of(context).textTheme.bodyText2,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'privacy policy',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: ', '),
                    TextSpan(
                      text: 'terms & conditions',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
              value: value,
              onChanged: (bool value) {
                setState(() {
                  this.value = value;
                });
              },
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              onPressed: () {},
              child: Text(
                'SIGNUP',
                style: Theme.of(context).textTheme.button,
              ),
            )
          ],
        ),
      ),
    );
  }
}
