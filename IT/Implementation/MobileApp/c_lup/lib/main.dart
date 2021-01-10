import 'package:c_lup/pages/ForgotPage.dart';
import 'package:c_lup/pages/HomePage.dart';
import 'package:c_lup/pages/LoginPage.dart';
import 'package:c_lup/pages/SignUpIntermediatePage.dart';
import 'package:c_lup/pages/SignUpPage.dart';
import 'package:c_lup/theme/MainTheme.dart';
import 'package:c_lup/utils/AuthService.dart';
import 'package:flutter/material.dart';

AuthService auth = new AuthService();

void main() async {
  Widget _defaultHome = new LoginPage();
  // bool _result = await auth.login();
  // if (_result) {
  //   _defaultHome = new HomePage();
  // }
  runApp(new MaterialApp(
    title: 'CLup',
    home: _defaultHome,
    theme: MainTheme.getLightTheme(),
    routes: {
      '/forgot': (context) => ForgotPage(),
      '/intermediate': (context) => SignUpIntermediatePage(),
      '/signup': (context) => SignUpPage(),
      '/home': (context) => HomePage(),
      '/login': (context) => LoginPage(),
    },
  ));
}


