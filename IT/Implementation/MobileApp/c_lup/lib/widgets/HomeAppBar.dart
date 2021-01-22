import 'package:c_lup/model/User.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor = Colors.red;
  final Text title;

  /// you can add more fields that meet your needs

  const HomeAppbar({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: this.title,
        centerTitle: true,
        leading: new Container(),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                            title: Text('Are you sure?', style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).accentColor)),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text(
                                      "Pressing \"Confirm\" will take you to the login page")
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                  child: Text('Cancel', style: Theme.of(context).textTheme.bodyText1),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              FlatButton(
                                  child: Text('Confirm', style: Theme.of(context).textTheme.bodyText1),
                                  onPressed: () async {
                                    var box = Hive.box<User>('properties');
                                    User user;
                                    box.put('user', user);
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, '/login', (route) => false);
                                  })
                            ],
                          ));
                },
                child: Icon(Icons.logout),
              )),
        ],
        elevation: 0.0,
        backgroundColor: Color(0x00ffffff),
        iconTheme:
            IconThemeData(color: Theme.of(context).accentColor, size: 30));
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
