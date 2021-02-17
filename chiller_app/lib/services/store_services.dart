

import 'package:cloud_firestore/cloud_firestore.dart';


class StoreServices {
  //this will only show top picked vendors, name sorted alphabetically
  getTopPickedStore(){
    return FirebaseFirestore.instance.collection('vendors').where('isTopPicked', isEqualTo: true).orderBy('shopName').snapshots();
  }
  //this will only show verified vendors, name sorted alphabetically
  getVerifiedStore(){
    return FirebaseFirestore.instance.collection('vendors').where('accVerified', isEqualTo: true).orderBy('shopName').snapshots();
  }
}

