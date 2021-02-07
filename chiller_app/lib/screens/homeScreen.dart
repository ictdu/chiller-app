import 'package:chiller_app/providers/auth_provider.dart';
import 'package:chiller_app/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home-screen';
  //when the user logged in successfully, this will be the screen.
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RaisedButton(
              onPressed: (){
                auth.error='';
                FirebaseAuth.instance.signOut().then((value){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>WelcomeScreen(),
                  ));
                });
              },
              child: Text('Sign Out',
                style: TextStyle(
                  color: Colors.black,
                ),),
            ),
            RaisedButton(
              onPressed: (){
                Navigator.pushNamed(context, WelcomeScreen.id);
              },
              child: Text('Home Screen',
                style: TextStyle(
                  color: Colors.black,
                ),),
            ),
          ],
        ),
      ),
    );
  }
}
