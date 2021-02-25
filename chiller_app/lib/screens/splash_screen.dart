import 'dart:async';

import 'package:chiller_app/screens/landing_screen.dart';
import 'package:chiller_app/screens/welcome_screen.dart';
import 'package:chiller_app/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homeScreen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User user = FirebaseAuth.instance.currentUser;

  //settings for how long the splashscreen will be
  @override
  void initState() {
    Timer(
        Duration(
          seconds: 3,
        ),(){
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if(user==null){
          Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        }else{
          //always go to landing screen first to check if the user has set his/her location or not
          //Navigator.pushReplacementNamed(context, LandingScreen.id);

          //check if there's a delivery address set by the user in firestore
          getUserData();
        }
      });
    }
    );
    super.initState();
  }

  getUserData()async{
    UserServices _userServices = UserServices();
    _userServices.getUserById(user.uid).then((result){
      //check if there's a location data
      if(result.data()['address']!=null){
        //if address details exists
        updatePrefs(result);
      }
      //if there's no address details exists
      Navigator.pushReplacementNamed(context, LandingScreen.id);
    });
  }

  Future<void>updatePrefs(result)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', result['latitude']);
    prefs.setDouble('longitude', result['longitude']);
    prefs.setString('address', result['address']);
    prefs.setString('location', result['location']);
    //after updating savedprefs, navigate to homescreen
    Navigator.pushReplacementNamed(context, HomeScreen.id);
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
            Text('Store Name',
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