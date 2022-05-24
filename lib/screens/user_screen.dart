import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:my_passwords/screens/home_screen.dart';
import 'package:my_passwords/screens/login_screen.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GNav(
          rippleColor: Colors.grey,
          // tab button ripple color when pressed
          hoverColor: Colors.grey,
          // tab button hover color
          haptic: true,
          // haptic feedback
          tabBorderRadius: 15,
          tabActiveBorder: Border.all(color: Colors.black, width: 1),
          // tab button border
          tabBorder: Border.all(color: Colors.grey, width: 1),
          // tab button border
          tabShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)
          ],
          // tab button shadow
          curve: Curves.easeOutExpo,
          // tab animation curves
          duration: const Duration(milliseconds: 900),
          // tab animation duration
          gap: 8,
          // the tab button gap between icon and text
          color: Colors.blueGrey,
          // unselected icon color
          activeColor: Colors.blueGrey,
          // selected icon and text color
          iconSize: 24,
          // tab button icon size
          tabBackgroundColor: Colors.purple.withOpacity(0.1),
          // selected tab background color
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          // navigation bar padding
          tabs: [
            GButton(
              active: true,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const UserScreen()),
                );
              },
              icon: Icons.person,
              text: 'User',
            ),
            GButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomesScreen()),
                );
              },
              icon: Icons.home,
              text: 'Passwords',
            ),

          ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.logout),
        backgroundColor: Colors.blueGrey,
        onPressed: () async {
          await FirebaseAuth.instance.signOut().then((value) =>
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LoginScreen())));
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Información de usuario'),
        leading: const Icon(Icons.person),
      ),
    );
  }
}
