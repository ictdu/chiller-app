import 'package:chiller_app/providers/location_provider.dart';
import 'package:chiller_app/screens/homeScreen.dart';
import 'package:chiller_app/screens/map_screen.dart';
import 'package:chiller_app/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingScreen extends StatefulWidget {
  static const String id = 'landing-screen';
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider _locationProvider = LocationProvider();
  User user = FirebaseAuth.instance.currentUser;
  String _location;
  String _address;

  @override
  void initState() {
    UserServices _userServices = UserServices();
    _userServices.getUserById(user.uid).then((result)async{
      if(result!=null){
        if(result.data()['latitude']!=null){
          getPrefs(result);
        }else{
          _locationProvider.getCurrentPosition();
          if(_locationProvider.permissionAllowed==true){
            Navigator.pushReplacementNamed(context, MapScreen.id);
          }else{
            print('Permission is not allowed');
          }
        }
      }
    });
    super.initState();
  }

  getPrefs(dbResult)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String location = prefs.getString('location');
    if (location == null){
      prefs.setString('address', dbResult.data()['location']); //location will not save on db
      prefs.setString('location', dbResult.data()['address']);
      setState(() {
        _location = dbResult.data()['location'];
        _address = dbResult.data()['address'];
      });
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    }
    Navigator.pushReplacementNamed(context, HomeScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_location == null ? '' : _location),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_address == null ? 'Delivery address is not set.' : _address, style:
              TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _address = null
                  ? 'Please update your delivery location to find the nearest stores from your location'
                  : _address, textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey
              ),
            ),
          ),
          Container(
            width: 600,
            child: Image.asset(
              'images/city.png',
              fit: BoxFit.fill,
              color: Colors.grey,
            ),
          ),
          Visibility(
            visible: _location != null ? true : false,
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              onPressed: (){
                Navigator.pushReplacementNamed(context, HomeScreen.id);
              },
              child: Text('Confirm Your Location'),
            ),
          ),
          FlatButton(
            color: Theme.of(context).primaryColor,
            onPressed: (){
              _locationProvider.getCurrentPosition();
              if(_locationProvider.permissionAllowed==true){
                Navigator.pushReplacementNamed(context, MapScreen.id);
              }else{
                print('Permission is not allowed.');
              }
            },
            child: Text(_location != null ? 'Update Location' : 'Confirm Your Location'),
          ),
        ],
      ),
    );
  }
}
