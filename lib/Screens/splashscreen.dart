import 'package:flutter/material.dart';
import 'package:habits_tracker/Screens/Authentication/Home/home.dart';
import 'package:habits_tracker/Screens/Authentication/login.dart';
import 'package:habits_tracker/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    checkLogin(context);
    return Scaffold(
      body: Container(alignment: Alignment.center, child: Text("Hello")),
    );
  }

  Future<void> checkLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    MyApp.of(context).changeTheme(0);
    await Future.delayed(Duration(seconds: 2));
    if (prefs.getString('token') == null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
        (val) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()),
        (val) => false,
      );
    }
  }
}
