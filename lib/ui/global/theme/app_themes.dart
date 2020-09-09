import 'package:flutter/material.dart';

enum AppTheme {
  Dark,
  Light,
}

final appThemeData = {
  AppTheme.Light: lightTheme,
  AppTheme.Dark: darkTheme,
};

final ThemeData lightTheme = ThemeData.light().copyWith(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: Color(0xff3389FF),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    elevation: 0.0,
    color: Colors.white,
  ),
  backgroundColor: Colors.grey[400],
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xff3389FF),
    splashColor: Color(0xff3369FF),
  ),
  brightness: Brightness.light,
  primaryColorLight: Color(0xff3359ee),
  splashColor: Color(0xff3359FF).withOpacity(0.5),
  highlightColor: Color(0xff3369FF).withOpacity(0.25),
  primaryColorDark: Colors.grey[600],
  cardColor: Colors.white,
  primaryIconTheme: IconThemeData().copyWith(
    color: Colors.black87,
  ),
  iconTheme: IconThemeData().copyWith(
    color: Colors.white,
  ),
  canvasColor: Colors.white,
  colorScheme: ColorScheme.light().copyWith(
    primary: Color(0xFF41d480),
    primaryVariant: Color(0xFF42f2ab),
    secondary: Color(0xFFff2323),
    secondaryVariant: Color(0xFFff5a5a),
    brightness: Brightness.light,
  ),
  textTheme: Typography.blackMountainView.copyWith(
    /// Headlines of screens
    headline1: TextStyle(
      fontFamily: 'OpenSans',
      color: Color(0xFF363636),
      fontWeight: FontWeight.bold,
    ),

    /// title of blue buttons
    button: TextStyle(
      fontFamily: 'OpenSans',
      color: Color(0xFFFFFFFF),
      fontWeight: FontWeight.w300,
    ),

    /// To be used in TextFormFields, Google SignIn Buttons and Verification
    /// page's body
    caption: TextStyle(
      fontFamily: 'OpenSans',
      color: Color(0xFF363636),
      fontWeight: FontWeight.w300,
    ),

    /// Main body text
    bodyText1: TextStyle(
      fontFamily: 'OpenSans',
      color: Color(0xFF5E5E5E),
      fontWeight: FontWeight.w600,
    ),

    /// Bottom nav-bar and top-card (you are owed/ you owe) text
    bodyText2: TextStyle(
      fontFamily: 'OpenSans',
      color: Color(0xFFFFFFFF),
      fontSize: 10,
    ),

    /// top card text
    headline2: TextStyle(
      fontFamily: 'OpenSans',
      color: Color(0xFFFFFFFF),
      fontWeight: FontWeight.w600,
    ),

    /// Red Font (you owe)
    subtitle1: TextStyle(
      fontFamily: 'OpenSans',
      color: Colors.red,
      fontWeight: FontWeight.w600,
    ),

    /// Green font (you are owed)
    subtitle2: TextStyle(
      fontFamily: 'OpenSans',
      color: Colors.green,
      fontWeight: FontWeight.w600,
    ),

    /// Credits text (made by)
    headline3: TextStyle(
      fontFamily: 'OpenSans',
      color: Color(0xFF7D7D7D),
      fontWeight: FontWeight.w600,
    ),

    /// TimeStamp text (in notes page) and "or connect with" text
    headline4: TextStyle(
      fontFamily: 'OpenSans',
      color: Color(0xFF525252),
    ),

    /// Title of "Settle Up" button in profile page
    headline5: TextStyle(
      fontFamily: 'OpenSans',
      color: Color(0xFF3389FF),
    ),

    /// "Sign Up", "FORGET PASSWORD", "Sign In" texts
    headline6: TextStyle(
      fontFamily: 'OpenSans',
      color: Color(0xFF3389FF),
      fontWeight: FontWeight.w600,
    ),
  ),
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: Color(0xff5468FF),
  scaffoldBackgroundColor: Color(0xFF181532),
  appBarTheme: AppBarTheme(
    elevation: 0.0,
    color: Color(0xFF181532),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xff4460FF),
    splashColor: Color(0xff4460FF),
  ),
  brightness: Brightness.dark,
  primaryColorLight: Color(0xff3359ee),
  splashColor: Color(0xff5468FF).withOpacity(0.5),
  highlightColor: Color(0xff5468FF).withOpacity(0.25),
  primaryColorDark: Colors.grey[700].withAlpha(200),
  cardColor: Color(0xFF181532),
  dialogBackgroundColor: Color(0xFF181532),
  timePickerTheme: TimePickerThemeData().copyWith(
    backgroundColor: Color(0xFF181532).withAlpha(120),
    dialBackgroundColor: Color(0xFF181532).withOpacity(0.85),
    dayPeriodColor: Color(0xFF181532).withOpacity(0.85),
  ),
  backgroundColor: Color(0xFF181545),
  primaryIconTheme: IconThemeData().copyWith(
    color: Colors.white,
  ),
  iconTheme: IconThemeData().copyWith(
    color: Colors.white,
  ),
  canvasColor: Color(0xFF181532),
  colorScheme: ColorScheme.light().copyWith(
    primaryVariant: Color(0xff0addaa),
    primary: Color(0xFf1adfbb),
    secondary: Color(0xFFff5a5a),
    secondaryVariant: Color(0xFFff555d),
    onSurface: Colors.white,
    surface: Color(0xFF181532).withAlpha(200),
    background: Color(0xFF181532),
    brightness: Brightness.dark,
  ),
  textTheme: Typography.blackMountainView.copyWith(
    /// Headlines of screens
    headline1: TextStyle(
      fontFamily: 'OpenSans',
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),

    /// title of blue buttons
    button: TextStyle(
      fontFamily: 'OpenSans',
      color: Colors.white,
      fontWeight: FontWeight.w300,
    ),

    /// To be used in TextFormFields, Google SignIn Buttons and Verification
    /// page's body
    caption: TextStyle(
      fontFamily: 'OpenSans',
      color: Colors.white.withOpacity(0.90),
      fontWeight: FontWeight.w300,
    ),

    /// Main body text
    bodyText1: TextStyle(
      fontFamily: 'OpenSans',
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),

    /// Bottom nav-bar and top-card (you are owed/ you owe) text
    bodyText2: TextStyle(
      fontFamily: 'OpenSans',
      color: Colors.white,
      fontSize: 10,
    ),

    /// top card text
    headline2: TextStyle(
      fontFamily: 'OpenSans',
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),

    /// Red Font (you owe)
    subtitle1: TextStyle(
      fontFamily: 'OpenSans',
      color: Color(0xFFff555d),
      fontWeight: FontWeight.w600,
    ),

    /// Green font (you are owed)
    subtitle2: TextStyle(
      fontFamily: 'OpenSans',
      color: Color(0xff0affef),
      fontWeight: FontWeight.w600,
    ),

    /// Credits text (made by)
    headline3: TextStyle(
      fontFamily: 'OpenSans',
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),

    /// TimeStamp text (in notes page) and "or connect with" text
    headline4: TextStyle(
      fontFamily: 'OpenSans',
      color: Colors.white.withOpacity(0.85),
    ),

    /// Title of "Settle Up" button in profile page
    headline5: TextStyle(
      fontFamily: 'OpenSans',
      color: Color(0xff5468FF),
    ),

    /// "Sign Up", "FORGET PASSWORD", "Sign In" texts
    headline6: TextStyle(
      fontFamily: 'OpenSans',
      color: Color(0xff5468FF),
      fontWeight: FontWeight.w600,
    ),
  ),
);
