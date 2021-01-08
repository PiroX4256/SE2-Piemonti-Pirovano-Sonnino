import 'package:c_lup/pages/HomePage.dart';
import 'package:c_lup/theme/MainTheme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: MainTheme.getLightTheme(),
      home: HomePage(title: 'CLup'),
    );
  }
}

