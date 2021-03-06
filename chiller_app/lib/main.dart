import 'package:chiller_app/providers/auth_provider.dart';
import 'package:chiller_app/providers/location_provider.dart';
import 'package:chiller_app/providers/store_provider.dart';
import 'package:chiller_app/screens/favourite_screen.dart';
import 'package:chiller_app/screens/homeScreen.dart';
import 'package:chiller_app/screens/landing_screen.dart';
import 'package:chiller_app/screens/login_screen.dart';
import 'package:chiller_app/screens/main_screen.dart';
import 'package:chiller_app/screens/map_screen.dart';
import 'package:chiller_app/screens/orders_screen.dart';
import 'package:chiller_app/screens/splash_screen.dart';
import 'package:chiller_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_)=>AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_)=>LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_)=>StoreProvider(),
        ),
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
        HomeScreen.id:(context)=>HomeScreen(),
        WelcomeScreen.id:(context)=>WelcomeScreen(),
        MapScreen.id:(context)=>MapScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        LandingScreen.id:(context)=>LandingScreen(),
        MainScreen.id:(context)=>MainScreen(),
        FavouriteScreen.id:(context)=>FavouriteScreen(),
        MyOrders.id:(context)=>MyOrders(),
        FavouriteScreen.id:(context)=>FavouriteScreen(),
      },
    );
  }
}

