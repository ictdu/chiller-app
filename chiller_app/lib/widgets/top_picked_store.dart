import 'package:chiller_app/providers/store_provider.dart';
import 'package:chiller_app/services/store_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class TopPickedStore extends StatefulWidget {
  @override
  _TopPickedStoreState createState() => _TopPickedStoreState();
}

class _TopPickedStoreState extends State<TopPickedStore> {
  StoreServices _storeServices = StoreServices();

  @override
  Widget build(BuildContext context) {
    final _storeData = Provider.of<StoreProvider>(context);
    _storeData.getUserLocationData(context);

    String getDistance(location){
      var distance = Geolocator.distanceBetween(
          _storeData.userLatitude, _storeData.userLongitude, location.latitude, location.longitude);
      var distanceInKm = distance / 1000; //this will show the vendors within 1 kilometer range
      return distanceInKm.toStringAsFixed(2);
    }
    return Container(
      color: Colors.white,
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getTopPickedStore(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot){
          if(!snapShot.hasData)return CircularProgressIndicator();
          //confirm if there are nearby store or none
          List shopDistance = [];
          for(int i=0 ; i<snapShot.data.docs.length-1; i++){
            var distance = Geolocator.distanceBetween(
                _storeData.userLatitude, _storeData.userLongitude, snapShot.data.docs[i]['location'].latitude, snapShot.data.docs[i]['location'].longitude);
            var distanceInKm = distance/1000;
            shopDistance.add(distanceInKm);
          }
          //this will sort the nearest store if the store is more than 20km from the user, that means no shop nearby
          shopDistance.sort();
          if(shopDistance[0]>10){
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Sorry, we currently don\'t have service in your area.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                  ),
                ),
              ),
            );
          }
          return Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
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
                  ),
                  Flexible(
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
