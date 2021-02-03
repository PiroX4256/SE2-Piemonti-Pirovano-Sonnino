import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///Main app's theme class.
class MainTheme {
  static const Color primaryColor = Color(0xffF85F6A);
  static const Color textMain = Color(0xffF85F6A);
  static const Color textAlternative = Color(0xffffffff);
  static const Color textGray = Color(0xff8A888A);
  static const Color accentColor = Color(0xffF85F6A);
  static const Color buttonColor = Color(0xffF85F6A);
  static const Color backgroundColor = Color(0xffE8E6E8);
  static const Color shadowColor = Color(0xffF85F6A);
  static const Color errorColor = Color(0xffD73E3D);

  static ThemeData getLightTheme() => ThemeData(
      primaryColor: primaryColor,
      fontFamily: 'Roboto',
      accentColor: accentColor,
      accentColorBrightness: Brightness.light,
      backgroundColor: backgroundColor,
      brightness: Brightness.light,
      buttonColor: buttonColor,
      errorColor: errorColor,
      shadowColor: shadowColor,
      textTheme: GoogleFonts.robotoTextTheme(TextTheme(
          bodyText1: TextStyle(fontSize: 18, color: textMain),
          bodyText2: TextStyle(fontSize: 12, color: primaryColor),
          headline4: TextStyle(
              fontSize: 36, color: textMain, fontWeight: FontWeight.w700),
          headline5: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w600, color: textMain),
          headline6: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: textGray),
          caption: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, color: textMain),
          button: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textAlternative))));
}
