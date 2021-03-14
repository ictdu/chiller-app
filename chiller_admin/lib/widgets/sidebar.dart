import 'package:chiller_admin/screens/admin_users.dart';
import 'package:chiller_admin/screens/category_screen.dart';
import 'package:chiller_admin/screens/delivery_person.dart';
import 'package:chiller_admin/screens/home_screen.dart';
import 'package:chiller_admin/screens/login_screen.dart';
import 'package:chiller_admin/screens/manage_banners.dart';
import 'package:chiller_admin/screens/notification_screen.dart';
import 'package:chiller_admin/screens/orders_screen.dart';
import 'package:chiller_admin/screens/settings_screen.dart';
import 'package:chiller_admin/screens/vendor_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class SideBarWidget{
  sideBarMenus(context, selectedRoute){
    return SideBar(
      activeBackgroundColor: Colors.black54,
      activeIconColor: Colors.white,
      activeTextStyle: TextStyle(color: Colors.white),
      items: const [
        MenuItem(
          title: 'Dashboard',
          route: HomeScreen.id,
          icon: Icons.dashboard,
        ),
        MenuItem(
          title: 'Banners',
          route: BannerScreen.id,
          icon: CupertinoIcons.photo,
        ),
        MenuItem(
          title: 'Vendors',
          route: VendorScreen.id,
          icon: CupertinoIcons.group_solid,
        ),
        MenuItem(
          title: 'Delivery Person',
          route: DeliveryScreen.id,
          icon: Icons.delivery_dining,
        ),
        MenuItem(
          title: 'Categories',
          route: CategoryScreen.id,
          icon: Icons.category,
        ),
        MenuItem(
          title: 'Orders',
          route: OrdersScreen.id,
          icon: CupertinoIcons.cart_fill,
        ),
        MenuItem(
          title: 'Send Notification',
          route: NotificationScreen.id,
          icon: Icons.notifications,
        ),
        MenuItem(
          title: 'Admin Users',
          route: AdminUsers.id,
          icon: Icons.admin_panel_settings_outlined,
        ),
        MenuItem(
          title: 'Settings',
          route: SettingsScreen.id,
          icon: Icons.settings,
        ),
        MenuItem(
          title: 'Exit',
          route: LoginScreen.id,
          icon: Icons.logout,
        ),
      ],
      selectedRoute: selectedRoute,
      onSelected: (item) {
        Navigator.of(context).pushNamed(item.route);
      },
      header: Container(
        height: 45,
        width: double.infinity,
        color: Colors.grey.withOpacity(1),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 65,),
              Image.asset('images/logo.png', height: 40,),
              Text(
                'MENU',
                style: TextStyle(
                  letterSpacing: 2,
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ),
      footer: Container(
        height: 25,
        width: double.infinity,
        color: Colors.grey.withOpacity(1),
        child: Center(
            child: Text(
              '©ICTDU 2021',
              style: TextStyle(
                  letterSpacing: 2,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
            ),
        ),
      ),
    );
  }
}