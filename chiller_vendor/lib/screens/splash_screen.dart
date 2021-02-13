import 'dart:async';


import 'package:chiller_vendor/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';


class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  //settings for how long the splashscreen will be
  @override
  void initState() {
    Timer(
        Duration(
          seconds: 3,
        ),(){
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if(user==null){
          Navigator.pushReplacementNamed(context, RegisterScreen.id);
        }else{
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        }
      });
    }
    );
    super.initState();
  }

  //splashscreen design (image and text)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/splashlogo.png', width: 150, height: 150,),
            Text('Store Name - Vendor',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),)
          ],
        ),
      ),
    );
  }
}