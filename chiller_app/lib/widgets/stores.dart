import 'package:chiller_app/screens/welcome_screen.dart';
import 'package:chiller_app/services/store_services.dart';
import 'package:chiller_app/services/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Stores extends StatefulWidget {
  @override
  _StoresState createState() => _StoresState();
}

class _StoresState extends State<Stores> {
  StoreServices _storeServices = StoreServices();
  UserServices _userServices = UserServices();
  User user = FirebaseAuth.instance.currentUser;
  var _userLatitude = 0.0;
  var _userLongitude = 0.0;


  //find user latitude and longitude to calculate the area around it
  @override
  void initState() {
    _userServices.getUserById(user.uid).then((result){
      if(mounted) {
        if (user != null) {
          setState(() {
            _userLatitude = result.data()['latitude'];
            _userLongitude = result.data()['longitude'];
          });
        } else {
          Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        }
      }});
    super.initState();
    }

  String getDistance(location){
    var distance = Geolocator.distanceBetween(_userLatitude, _userLongitude, location.latitude, location.longitude);
    var distanceInKm = distance / 1000; //this will show the vendors within 1 kilometer range
    return distanceInKm.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getTopPickedStore(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot){
          if(!snapShot.hasData)return CircularProgressIndicator();
          //confirm if there are nearby store or none
          List shopDistance = [];
          for(int i=0 ; i<snapShot.data.docs.length-1; i++){
            var distance = Geolocator.distanceBetween(_userLatitude, _userLongitude, snapShot.data.docs[i]['location'].latitude, snapShot.data.docs[i]['location'].longitude);
            var distanceInKm = distance/1000;
            shopDistance.add(distanceInKm);
          }
          //this will sort the nearest store if the store is more than 20km from the user, that means no shop nearby
          shopDistance.sort();
          if(shopDistance[0]>10){
            return Container();
          }
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 30,
                      child: Image.asset('images/like.gif'),
                    ),
                    Text('Top Picked Stores For You', style:
                    TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                    ),
                  ],
                ),
                Container(
                  child: Flexible(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapShot.data.docs.map((DocumentSnapshot document){
                        //show vendors within 20km range
                        if(double.parse(getDistance(document['location']))<20){
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              width: 80,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Card(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Image.network(document['imageUrl'], fit: BoxFit.cover,),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 35,
                                    child: Text(document['shopName'], style:
                                    TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                  ),
                                  Text('${getDistance(document['location'])} Km', style:
                                  TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey
                                  ),)
                                ],
                              ),
                            ),
                          );
                        }else{
                          //if no vendor(s) within the 20km range
                          return Container();
                        }

                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
