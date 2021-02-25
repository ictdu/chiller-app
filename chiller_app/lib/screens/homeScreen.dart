import 'package:chiller_app/providers/auth_provider.dart';
import 'package:chiller_app/widgets/image_slider.dart';
import 'package:chiller_app/widgets/my_appbar.dart';
import 'package:chiller_app/widgets/nearby_store.dart';
import 'package:chiller_app/widgets/top_picked_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(112),
        child: MyAppBar(),
      ),
      body: ListView(
        children: [
          ImageSlider(),
          Container(
            child: TopPickedStore(),
          ),
          NearbyStores(),
        ],
      ),
    );
  }
}
