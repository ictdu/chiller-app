import 'package:chiller_app/widgets/image_slider.dart';
import 'package:chiller_app/widgets/my_appbar.dart';
import 'package:chiller_app/widgets/nearby_store.dart';
import 'package:chiller_app/widgets/top_picked_store.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
          return [
            MyAppBar()
          ];
        },
        body: ListView(
          children: [
            ImageSlider(),
            Container(
              color: Colors.white,
              child: TopPickedStore(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: NearbyStores(),
            ),
          ],
        ),
      ),
    );
  }
}
