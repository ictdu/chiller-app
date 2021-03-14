import 'dart:async';

import 'package:chiller_admin/screens/home_screen.dart';
import 'package:chiller_admin/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(
      Duration(seconds: 2),(){
        FirebaseAuth.instance
            .authStateChanges()
            .listen((User user) {
          if(user == null){
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
          }else{
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
          }
        });
    }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/logo.png', width: 100, height: 100,),
            Text('Chiller Admin',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),),
            SizedBox(height: 18,),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
