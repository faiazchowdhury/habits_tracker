import 'package:flutter/material.dart';
import 'package:habits_tracker/Screens/Authentication/Home/TextIconButton.dart';
import 'package:habits_tracker/Screens/Authentication/Home/home.dart';
import 'package:habits_tracker/Screens/Authentication/login.dart';
import 'package:habits_tracker/Screens/Profile/profile.dart';
import 'package:habits_tracker/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextIconButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => Home(),
                    ),
                  ),
                  icon: Icons.home,
                  label: 'Home Screen',
                ),
                TextIconButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => Login(),
                    ),
                  ),
                  icon: Icons.shopping_cart,
                  label: 'My Cart',
                ),
                
                TextIconButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Profile(),
                    ),
                  ),
                  icon: Icons.person,
                  label: 'Profile',
                ),
                SizedBox(
                  height: 10,
                ),
                ToggleSwitch(
                  initialLabelIndex:
                      MyApp.of(context).getTheme() == ThemeMode.light ? 0 : 1,
                  minWidth: 170,
                  onToggle: (index) => MyApp.of(context).changeTheme(1),
                  activeBgColors: [
                    [Theme.of(context).primaryColor.withOpacity(0.8)],
                    [Theme.of(context).primaryColor.withOpacity(0.8)]
                  ],
                  labels: ["Light Mode", "Dark Mode"],
                ),
                const Divider(
                  height: 50,
                  color: Colors.black,
                  thickness: 1,
                ),
                TextIconButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => Login(),
                      ),
                      (route) => false,
                    );
                  },
                  icon: Icons.logout,
                  label: 'Log Out',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}