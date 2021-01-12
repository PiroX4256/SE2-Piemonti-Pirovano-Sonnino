import 'package:c_lup/model/User.dart';
import 'package:c_lup/pages/ForgotPage.dart';
import 'package:c_lup/pages/HomePage.dart';
import 'package:c_lup/pages/LoginPage.dart';
import 'package:c_lup/pages/SignUpIntermediatePage.dart';
import 'package:c_lup/pages/SignUpPage.dart';
import 'package:c_lup/theme/MainTheme.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Widget _defaultHome = new LoginPage();
  await Hive.initFlutter();
  Hive.registerAdapter<User>(UserAdapter());
  var box = await Hive.openBox('properties');
  User user = box.get('user');
  if(user != null && user.token != null){
    _defaultHome = new HomePage();
  }
  runApp(MyApp(home: _defaultHome));
}
class MyApp extends StatelessWidget{
  final Widget home;
  MyApp({
    @required this.home,
  });
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CLup',
      home: home,
      theme: MainTheme.getLightTheme(),
      routes: {
        '/forgot': (context) => ForgotPage(),
        '/intermediate': (context) => SignUpIntermediatePage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
