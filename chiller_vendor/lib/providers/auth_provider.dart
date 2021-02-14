

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AuthProvider extends ChangeNotifier {
  File image;
  bool isPicAvail = false;
  String pickerError = '';
  String error = '';

  //shop data
  double shopLatitude;
  double shopLongitude;
  String shopAddress;
  String placeName;
  String email;


  //image getter
  Future<File> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 20); //reduce image size
    if (pickedFile != null){
      this.image = File(pickedFile.path);
    }else{
      this.pickerError = 'No image selected.';
      print('No image selected.');
      notifyListeners();
    }
    return this.image;
  }

  //get current address
  Future getCurrentAddress() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    this.shopLatitude = _locationData.latitude;
    this.shopLongitude = _locationData.longitude;
    notifyListeners();

    final coordinates = new Coordinates(_locationData.latitude, _locationData.longitude);
    var _addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var shopAddress = _addresses.first;
    this.shopAddress = shopAddress.addressLine;
    this.placeName = shopAddress.featureName;
    notifyListeners();
    return shopAddress;
  }

  //register using email
  Future<UserCredential> registerVendor(email, password) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.error = 'The password provided is too weak.';
        notifyListeners();
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        this.error = 'The account already exists for that email.';
        notifyListeners();
        print('The account already exists for that email.');
      }
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

  //save vendor data to Firestore
  Future<void> savedVendorDataToDb({
  String url, String shopName, String mobile, String dialog}){
    User user = FirebaseAuth.instance.currentUser;
    DocumentReference _vendors = FirebaseFirestore.instance.collection('vendors').doc(user.uid);
    _vendors.set({
      'uid':user.uid,
      'shopName':shopName,
      'mobile':mobile,
      'email':this.email,
      'dialog':dialog,
      'address':'${this.placeName}: ${this.shopAddress}',
      'location':GeoPoint(this.shopLatitude, this.shopLongitude),
      'shopOpen':true, //for future use
      'rating':0.00, //for future use
      'totalRating':0, //for future use
      'isTopPicked':true, //for future use
      'imageUrl':url,
    });
    return null;
  }
}