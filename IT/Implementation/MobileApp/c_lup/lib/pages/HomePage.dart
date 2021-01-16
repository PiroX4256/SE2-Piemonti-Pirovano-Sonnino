import 'dart:io';

import 'package:c_lup/model/User.dart';
import 'package:c_lup/utils/Generator.dart';
import 'package:c_lup/widgets/MainAppbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var box;
  User user;
  Future<bool> _bookings;

  @override
  void initState() async {
    super.initState();
    box = await Hive.openBox('properties');
    user = box.get('user');
    _bookings = Generator.fetchBookings(user.token);
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.show();
    return Scaffold(
      appBar: MainAppbar(),
      body: Center(
        child: ListView(
          children: <Widget>[
            FutureBuilder<bool>(
                future: _bookings,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData) {
                    return Table();
                  } else {
                    EasyLoading.show();
                    return Container();
                  }
                }),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              onPressed: () {},
              child: Text(
                'RETRIEVE A TICKET',
                style: Theme.of(context).textTheme.button,
              ),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              onPressed: () {},
              child: Text(
                'BOOK A TICKET',
                style: Theme.of(context).textTheme.button,
              ),
            )
          ],
        ),
      ),
    );
  }
}
