import 'package:chiller_admin/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class AdminUsers extends StatelessWidget {
  static const String id = 'admin-users';
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
      sideBar: _sideBar.sideBarMenus(context, AdminUsers.id),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Text(
              'Manage Admins',
              style: TextStyle(
              ),
            ),
          ),
        ),
      ),
    );
  }
}
