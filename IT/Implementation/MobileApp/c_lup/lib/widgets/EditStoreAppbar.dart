import 'package:c_lup/model/User.dart';
import 'package:c_lup/utils/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

class EditStoreAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor = Colors.red;
  final Text title;
  final String selectedStore;

  /// you can add more fields that meet your needs

  const EditStoreAppbar({Key key, this.title, this.selectedStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: this.title,
        centerTitle: true,
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
                                  "Pressing \"Confirm\" will select the current store")
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
                                User user = box.get('user');
                                user.setStoreId(selectedStore);
                                box.put('user', user);
                                Navigator.pushNamedAndRemoveUntil(
                                     context, '/home', (route) => false);
                              })
                        ],
                      ));
                },
                child: Icon(Icons.done),
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
