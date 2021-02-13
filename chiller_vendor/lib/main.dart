
import 'package:chiller_vendor/providers/auth_provider.dart';
import 'package:chiller_vendor/screens/home_screen.dart';
import 'package:chiller_vendor/screens/register_screen.dart';
import 'package:chiller_vendor/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        Provider(create: (_) => AuthProvider()),
      ],
    child: MyApp(),
  ),
  );
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
        RegisterScreen.id:(context)=>RegisterScreen(),
        HomeScreen.id:(context)=>HomeScreen(),
      },
    );
  }
}

