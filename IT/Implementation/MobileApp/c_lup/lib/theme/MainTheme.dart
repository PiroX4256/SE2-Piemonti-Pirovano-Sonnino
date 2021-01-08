import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainTheme {
  static const Color textMain = Color(0xff8a888a);
  static const Color accentColor = Color(0xffE8E6E8);
  static const Color buttonColor = Color(0xff787778);


  static ThemeData getLightTheme() => ThemeData(
      fontFamily: 'Roboto',
      accentColor: accentColor,
      accentColorBrightness: Brightness.light,
      backgroundColor: accentColor,
      brightness: Brightness.light,
      buttonColor: buttonColor,
      textTheme: GoogleFonts.robotoTextTheme(TextTheme(
        bodyText1: TextStyle(fontSize: 18, color: textMain),
        headline4: TextStyle(
            fontSize: 36, color: textMain, fontWeight: FontWeight.w700),
        headline5: TextStyle(
            fontSize: 24, fontWeight: FontWeight.w600, color: textMain),
        caption: TextStyle(
            fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
      )));

  //TODO  DART THEME NON SONO SICURO CHE RESETTANDO FUNZIONI

}
