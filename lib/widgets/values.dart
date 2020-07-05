import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: Colors.black,
  accentColor: Colors.white,
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.black12,
  scaffoldBackgroundColor: Colors.black,
);

final lightTheme = ThemeData(
  appBarTheme: AppBarTheme(elevation: 0),
  canvasColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  textTheme: TextTheme(
    bodyText1: TextStyle(
      color: Color.fromRGBO(104, 97, 123, 1),
    ),
    headline1: TextStyle(
      color: Color.fromRGBO(104, 97, 123, 1),
    ),
    bodyText2: TextStyle(
      color: Color.fromRGBO(104, 97, 123, 1),
    ),
    caption: TextStyle(
      color: Color.fromRGBO(104, 97, 123, 1),
    ),
    button: TextStyle(
      color: Color.fromRGBO(104, 97, 123, 1),
    ),
    headline2: TextStyle(
      color: Color.fromRGBO(104, 97, 123, 1),
    ),
    headline3: TextStyle(
      color: Color.fromRGBO(104, 97, 123, 1),
    ),
    headline4: TextStyle(
      color: Color.fromRGBO(104, 97, 123, 1),
    ),
    headline5: TextStyle(
      color: Color.fromRGBO(104, 97, 123, 1),
    ),
    headline6: TextStyle(
      color: Colors.black,
    ),
    overline: TextStyle(
      color: Color.fromRGBO(104, 97, 123, 1),
    ),
    subtitle1: TextStyle(
      color: Colors.grey,
    ),
    subtitle2: TextStyle(
      color: Colors.black,
    ),
  ),
  primaryColor: Colors.white,
  primaryIconTheme: IconThemeData(
    color: Color.fromRGBO(104, 97, 123, 1),
  ),
  primarySwatch: Colors.grey,
  accentColor: Colors.black,
  accentIconTheme: IconThemeData(color: Colors.white),
  dividerColor: Color(0xffd7ddf0),
);
