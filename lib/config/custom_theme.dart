import 'package:flutter/material.dart';

ThemeData custom_theme = ThemeData().copyWith(
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF050B48),
    onPrimary: Color(0xFF0ba074),
    secondary: Color(0xFFd73485),
    onSecondary: Color(0xFFe6bd2d),
    error: Colors.red,
    onError: Colors.redAccent,
    surface: Color(0xFF3652e4),
    onSurface: Colors.black,
    // onSurface: Color(0xFF4382e7),
  ),
);
