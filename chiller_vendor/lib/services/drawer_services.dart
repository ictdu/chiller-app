import 'package:chiller_vendor/screens/banner_screen.dart';
import 'package:chiller_vendor/screens/dashboard_screen.dart';
import 'package:chiller_vendor/screens/product_screen.dart';
import 'package:flutter/cupertino.dart';

class DrawerServices{
  Widget drawerScreen(title){
    if(title == 'Dashboard'){
      return MainScreen();
    }
    if(title == 'Products'){
      return ProductScreen();
    }
    if(title == 'Banner'){
      return BannerScreen();
    }
    return MainScreen();
  }
}