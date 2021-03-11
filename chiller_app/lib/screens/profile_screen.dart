import 'package:chiller_app/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = 'profile-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('Sign Out'),
          onPressed: (){
            FirebaseAuth.instance.signOut();
            pushNewScreenWithRouteSettings(
              context,
              settings: RouteSettings(name: WelcomeScreen.id),
              screen: WelcomeScreen(),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );


          },
        ),
      ),
    );
  }
}
