import 'package:chiller_app/constants.dart';
import 'package:chiller_app/providers/store_provider.dart';
import 'package:chiller_app/services/store_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class NearbyStores extends StatefulWidget {
  @override
  _NearbyStoresState createState() => _NearbyStoresState();
}

class _NearbyStoresState extends State<NearbyStores> {
  StoreServices _storeServices = StoreServices();
  PaginateRefreshedChangeListener refreshedChangeListener = PaginateRefreshedChangeListener();

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
        stream: _storeServices.getNearbyStore(), //will change in the future
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapShot){
          if(!snapShot.hasData)return
              CircularProgressIndicator();
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
            return Container(
              child: Stack(
                children: [
                  Center(
                      child: Text(
                        '**That\'s all folks!**', style:
                      TextStyle(
                        color: Colors.grey,
                      ),
                      ),
                    ),
                  SizedBox(
                    height: 40,
                  ),
                  Image.asset('images/city.png', color: Colors.black12,),
                  Positioned(
                    right: 10.0,
                    top: 80,
                    child: Container(
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Made by ', style:
                          TextStyle(
                              color: Colors.black54
                          ),
                          ),
                          Text('ICTDU team', style:
                          TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Anton',
                              letterSpacing: 2,
                              color: Colors.grey
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Padding(
              padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RefreshIndicator(
                  child: PaginateFirestore(
                    bottomLoader: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      ),
                    ),
                    header: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8, top: 20),
                          child: Text('All Nearby Stores', style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18
                          ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
                          child: Text('Find quality products near you', style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11
                          ),
                          ),
                        ),
                      ],
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilderType: PaginateBuilderType.listView,
                    itemBuilder: (index, content, document) =>
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 110,
                              child: Card(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(document['imageUrl'], fit: BoxFit.cover,),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(document.data()['shopName'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(document.data()['dialog'], style: kStoreCardStyle,),
                                SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width-250,
                                  child: Text(
                                    document.data()['address'],
                                    overflow: TextOverflow.ellipsis,
                                    style: kStoreCardStyle,
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  '${getDistance(document['location'])} Km',
                                  overflow: TextOverflow.ellipsis,
                                  style: kStoreCardStyle,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  //this is for Ratings, will work on it later
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      '3.2',
                                      style: kStoreCardStyle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    query: _storeServices.getNearbyStorePagination(),
                    listeners: [
                      refreshedChangeListener,
                    ],
                    footer: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                '**That\'s all folks!**', style:
                                TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Image.asset('images/city.png', color: Colors.black12,),
                            Positioned(
                              right: 10.0,
                              top: 80,
                              child: Container(
                                width: 100,
                                  child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Made by ', style:
                                        TextStyle(
                                          color: Colors.black54
                                        ),
                                      ),
                                      Text('ICTDU team', style:
                                        TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Anton',
                                          letterSpacing: 2,
                                          color: Colors.grey
                                        ),
                                      ),
                                    ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onRefresh: ()async{
                    refreshedChangeListener.refreshed = true;
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
