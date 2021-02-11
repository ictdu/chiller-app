import 'package:chiller_vendor/screens/auth_screen.dart';
import 'package:chiller_vendor/screens/home_screen.dart';
import 'package:chiller_vendor/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(),);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor:  Colors.lightBlueAccent,
          fontFamily: 'Lato'
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id:(context)=>SplashScreen(),
        AuthScreen.id:(context)=>AuthScreen(),
        HomeScreen.id:(context)=>HomeScreen(),
      },
    );
  }
}

