import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

DrawerThemeData myDrawerTheme =
    const DrawerThemeData(backgroundColor: Colors.white);

List<AppTheme> myThemes = [
  AppTheme(
    id: "default_light", // Id(or name) of the theme(Has to be unique)
    description: "The Default Light Theme", // Description of theme
    data: ThemeData(
        drawerTheme: myDrawerTheme,
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.black, // indicator in text edit
          onPrimary: Color(0xff202020),
          secondary: Color(0xff202020),
          onSecondary: Color(0xff202020),
          error: Colors.red,
          onError: Colors.red,
          background: Color.fromARGB(255, 255, 255, 255),
          onBackground: Color.fromARGB(255, 236, 167, 167), //Background Color
          surface: Color(0xff202020), // Dialog background Color
          onSurface: Color.fromARGB(255, 0, 0, 0), // Default Text Color
          outline: Color.fromARGB(255, 236, 167, 167),
        ),
        dialogTheme: const DialogTheme(surfaceTintColor: Colors.transparent),
        //splashColor: Colors.transparent,
        //highlightColor: Colors.transparent,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.green.shade200,
          unselectedItemColor: Colors.green.shade100,
        )),
  ),
  AppTheme(
    id: "blueblackbg2", // Id(or name) of the theme(Has to be unique)
    description: "BlueBlackBG2", // Description of theme
    data: ThemeData(
      drawerTheme: myDrawerTheme,
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xff48c0e8),
        onPrimary: Color(0xff202020),
        secondary: Color(0xff202020),
        onSecondary: Color(0xff202020),
        error: Colors.red,
        onError: Colors.red,
        background: Color(0xff202020),
        onBackground: Color(0xff48c0e8), //Background Color
        surface: Color(0xff202020), // Dialog background Color
        onSurface: Color(0xffffffff), // Default Text Color
        outline: Color(0xff48c0e8),
      ),
      dialogTheme: const DialogTheme(surfaceTintColor: Colors.transparent),
    ),
  ),
];
