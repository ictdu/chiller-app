import 'package:chiller_app/providers/location_provider.dart';
import 'package:chiller_app/screens/map_screen.dart';
import 'package:flutter/material.dart';


class LandingScreen extends StatefulWidget {
  static const String id = 'landing-screen';
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider _locationProvider = LocationProvider();
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Delivery address is not set.', style:
                TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                    'Please update your delivery location to find the nearest stores from your location', textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey
                ),
              ),
            ),
            CircularProgressIndicator(),
            Container(
              width: 600,
              child: Image.asset(
                'images/city.png',
                fit: BoxFit.fill,
                color: Colors.black12,
              ),
            ),
            _loading ? CircularProgressIndicator() : FlatButton(
              color: Theme.of(context).primaryColor,
              onPressed: ()async{
                setState(() {
                  _loading = true;
                });
                await _locationProvider.getCurrentPosition();
                if(_locationProvider.permissionAllowed == true){
                  Navigator.pushReplacementNamed(context, MapScreen.id);
                }else{
                  Future.delayed(Duration(seconds: 4),(){
                    if(_locationProvider.permissionAllowed == false){
                      print('Permission is not allowed.');
                      setState(() {
                        _loading = false;
                      });
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Please allow permission to access location'),
                      ));
                    }
                  });
                }
              },
              child: Text('Set Your Location',
              style: TextStyle(
                color: Colors.white,
              ),),
            ),
          ],
        ),
      ),
    );
  }
}
