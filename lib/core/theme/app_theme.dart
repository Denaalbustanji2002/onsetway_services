import 'package:flutter/material.dart';
import 'package:onsetway_services/constitem/const_colors.dart';

ThemeData appTheme() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: ConstColor.white,
    colorScheme: base.colorScheme.copyWith(
      primary: ConstColor.gold,
      secondary: ConstColor.darkGold,
      surface: ConstColor.white,
      onPrimary: ConstColor.black,
      onSurface: ConstColor.black,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ConstColor.darkGold, width: 1.6),
      ),
      labelStyle: TextStyle(color: ConstColor.black),
      errorMaxLines: 3,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ConstColor.gold,
        foregroundColor: ConstColor.black,
        minimumSize: const Size.fromHeight(48),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: ConstColor.darkGold),
    ),
  );
}
