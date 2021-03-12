import 'package:chiller_admin/screens/HomeScreen.dart';
import 'package:chiller_admin/screens/login_screen.dart';
import 'package:chiller_admin/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chiller App Admin Panel',
      theme: ThemeData(
        primarySwatch: Theme.of(context).primaryColor,
      ),
      home: SplashScreen(),
      routes: {
        HomeScreen.id:(context)=>HomeScreen(),
        SplashScreen.id:(context)=>SplashScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
      },
    );
  }
}

