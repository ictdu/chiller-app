import 'package:chiller_app/services/store_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Stores extends StatefulWidget {
  @override
  _StoresState createState() => _StoresState();
}

class _StoresState extends State<Stores> {
  @override
  Widget build(BuildContext context) {
    StoreServices _storeServices = StoreServices();
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getVerifiedStore(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot){
          if(!snapShot.hasData)return CircularProgressIndicator();
          List shopDistance = [];
          for(int i=0 ; i<snapShot.data.docs.length; i++){
            //to do
          }
          return Column(
            children: [
              Flexible(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: snapShot.data.docs.map((DocumentSnapshot document){
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
                            Text('20 Km', style:
                              TextStyle(
                                fontSize: 10,
                                color: Colors.grey
                              ),)
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
