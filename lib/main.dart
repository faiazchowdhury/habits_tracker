import 'package:flutter/material.dart';
import 'package:habits_tracker/Screens/Authentication/login.dart';
import 'package:habits_tracker/Screens/Constants/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:habits_tracker/Screens/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode getTheme() => _themeMode;

  Future<void> changeTheme(int i) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (i == 0) {
        if (prefs.getBool("theme") == null) {
          _themeMode = ThemeMode.light;
          prefs.setBool("theme", true);
        } else if (prefs.getBool("theme")!) {
          _themeMode = ThemeMode.light;
          prefs.setBool("theme", true);
        } else {
          _themeMode = ThemeMode.dark;
          prefs.setBool("theme", false);
        }
      } else {
        if (prefs.getBool("theme") == null) {
          _themeMode = ThemeMode.dark;
          prefs.setBool("theme", false);
        } else if (prefs.getBool("theme") == true) {
          _themeMode = ThemeMode.dark;
          prefs.setBool("theme", false);
        } else {
          _themeMode = ThemeMode.light;
          prefs.setBool("theme", true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _themeMode,
      title: 'Habit Tracker',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryColorLight,
        colorScheme: ColorScheme.light(
          primary: primaryColorLight,
          secondary: secondaryColorLight,
          surface: backgroundColorLight,
          onPrimary: Colors.white,
          onSecondary: textPrimaryLight,
          onSurface: textPrimaryLight,
          outline: textSecondaryLight,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            overlayColor: WidgetStatePropertyAll(
              backgroundColorLight.withValues(alpha: 0.2),
            ),
            backgroundColor: WidgetStateProperty.all(primaryColorLight),
          ),
        ),
        scaffoldBackgroundColor: backgroundColorLight,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: textPrimaryLight),
          bodyMedium: TextStyle(color: textSecondaryLight),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColorDark,
        colorScheme: ColorScheme.dark(
          primary: primaryColorDark,
          secondary: secondaryColorDark,
          surface: backgroundColorDark,
          onPrimary: Colors.black,
          onSecondary: textPrimaryDark,
          onSurface: textPrimaryDark,
          outline: textSecondaryDark,
        ),
        scaffoldBackgroundColor: backgroundColorDark,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: textPrimaryDark),
          bodyMedium: TextStyle(color: textSecondaryDark),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            overlayColor: WidgetStatePropertyAll(
              backgroundColorDark.withValues(alpha: 0.2),
            ),
            backgroundColor: WidgetStateProperty.all(primaryColorDark),
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
