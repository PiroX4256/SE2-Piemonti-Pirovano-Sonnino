import 'package:c_lup/model/Booking.dart';
import 'package:c_lup/model/Slot.dart';
import 'package:c_lup/model/User.dart';
import 'package:c_lup/pages/DeletePage.dart';
import 'package:c_lup/pages/EditStorePage.dart';
import 'package:c_lup/pages/ForgotPage.dart';
import 'package:c_lup/pages/HomePage.dart';
import 'package:c_lup/pages/LoginPage.dart';
import 'package:c_lup/pages/QrCodePage.dart';
import 'package:c_lup/pages/RetrievePage.dart';
import 'package:c_lup/pages/SignUpIntermediatePage.dart';
import 'package:c_lup/pages/SignUpPage.dart';
import 'package:c_lup/theme/MainTheme.dart';
import 'package:c_lup/utils/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/Reservation.dart';
import 'model/Store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Widget _defaultHome = new LoginPage();
  await Hive.initFlutter();
  Hive.registerAdapter<User>(UserAdapter());
  Hive.registerAdapter<Booking>(BookingAdapter());
  Hive.registerAdapter<Reservation>(ReservationAdapter());
  Hive.registerAdapter<Slot>(SlotAdapter());
  Hive.registerAdapter<Store>(StoreAdapter());
  var box = await Hive.openBox<User>('properties');
  User user = box.get('user');
  if (user != null && user.token != null && user.role != null) {
    bool auth = await AuthService.auth(user.token);
    if (auth) {
      _defaultHome = new HomePage();
    }
  }
  runApp(MyApp(home: _defaultHome));
}

class MyApp extends StatelessWidget {
  final Widget home;

  MyApp({
    @required this.home,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CLup',
      home: home,
      theme: MainTheme.getLightTheme(),
      routes: {
        '/forgot': (context) => ForgotPage(),
        '/intermediate': (context) => SignUpIntermediatePage(),
        '/sign-up': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/qr-code': (context) => QrCodePage(),
        '/delete-booking': (context) => DeletePage(),
        '/retrieve': (context) => RetrievePage(),
        '/edit-store': (context) => EditStorePage(),
      },
      builder: EasyLoading.init(),
    );
  }
}
