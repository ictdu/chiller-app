import 'package:chiller_admin/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  static const String id = 'settings-screen';
  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: const Text('Chiller Admin Dashboard',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      sideBar: _sideBar.sideBarMenus(context, SettingsScreen.id),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Text(
              'Settings Screen',
              style: TextStyle(
              ),
            ),
          ),
        ),
      ),
    );
  }
}
