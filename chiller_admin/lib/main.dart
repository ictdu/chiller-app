import 'package:chiller_admin/screens/admin_users.dart';
import 'package:chiller_admin/screens/home_screen.dart';
import 'package:chiller_admin/screens/category_screen.dart';
import 'package:chiller_admin/screens/login_screen.dart';
import 'package:chiller_admin/screens/manage_banners.dart';
import 'package:chiller_admin/screens/notification_screen.dart';
import 'package:chiller_admin/screens/orders_screen.dart';
import 'package:chiller_admin/screens/settings_screen.dart';
import 'package:chiller_admin/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
        BannerScreen.id:(context)=>BannerScreen(),
        CategoryScreen.id:(context)=>CategoryScreen(),
        OrdersScreen.id:(context)=>OrdersScreen(),
        NotificationScreen.id:(context)=>NotificationScreen(),
        AdminUsers.id:(context)=>AdminUsers(),
        SettingsScreen.id:(context)=>SettingsScreen(),
      },
    );
  }
}

