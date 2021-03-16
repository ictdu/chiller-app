import 'package:chiller_admin/widgets/sidebar.dart';
import 'package:chiller_admin/widgets/vendor_datatable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class VendorScreen extends StatefulWidget {
  static const String id = 'vendor-screen';

  @override
  _VendorScreenState createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
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
      sideBar: _sideBar.sideBarMenus(context, VendorScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage Vendors',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 36
                ),
              ),
              Text('Manage Vendors Activities'),
              Divider(thickness: 5),
              VendorDataTable(),
              Divider(thickness: 5),
            ],
          ),
        ),
      ),
    );
  }
}
