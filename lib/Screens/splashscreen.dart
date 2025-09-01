import 'package:flutter/material.dart';
import 'package:habits_tracker/Screens/Home/home.dart';
import 'package:habits_tracker/Screens/Authentication/login.dart';
import 'package:habits_tracker/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkLogin(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(alignment: Alignment.center, child: Text("Welcome!",
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 50
      ),
      )),
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
