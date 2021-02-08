import 'package:chiller_app/providers/auth_provider.dart';
import 'package:chiller_app/providers/location_provider.dart';
import 'package:chiller_app/screens/map_screen.dart';
import 'package:chiller_app/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String _location = '';

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  getPrefs()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String location = prefs.getString('location');
    setState(() {
      _location = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: Container(),
        title: FlatButton(
          onPressed: (){
            locationData.getCurrentPosition();
            if(locationData.permissionAllowed==true){
              Navigator.pushNamed(context, MapScreen.id);
            }else{
              print('Permission is not allowed');
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(_location == null ? 'Address is not set' : _location,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.edit_outlined,
                color: Colors.white,),
            ],
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.account_circle_outlined,
              color: Colors.white,),
              onPressed: (){

              },
          ),
        ],
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: Colors.grey,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none
                ),
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: Colors.white,

              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RaisedButton(
              onPressed: (){
                auth.error='';
                FirebaseAuth.instance.signOut().then((value){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>WelcomeScreen(),
                  ));
                });
              },
              child: Text('Sign Out',
                style: TextStyle(
                  color: Colors.black,
                ),),
            ),
            RaisedButton(
              onPressed: (){
                Navigator.pushNamed(context, WelcomeScreen.id);
              },
              child: Text('Home Screen',
                style: TextStyle(
                  color: Colors.black,
                ),),
            ),
          ],
        ),
      ),
    );
  }
}
