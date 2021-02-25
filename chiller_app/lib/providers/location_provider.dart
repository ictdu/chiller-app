import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  double latitude = 37.421632;
  double longitude = 122.084664;
  bool permissionAllowed = false;
  var selectedAddress;
  bool loading = false;

  //get user's position
  Future<void> getCurrentPosition()async{

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if(position!=null){
      this.latitude = position.latitude;
      this.longitude = position.longitude;
      final coordinates = new Coordinates(this.latitude, this.longitude);
      final addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      this.selectedAddress = addresses.first;
      this.permissionAllowed = true;
      notifyListeners();
    }else{
      print('Permission is not allowed');
    }
  }

  //when google map camera moved
  void onCameraMove(CameraPosition cameraPosition)async{
    this.latitude = cameraPosition.target.latitude;
    this.longitude = cameraPosition.target.longitude;
    notifyListeners();
  }

  //for geocoder
  Future<void>getMoveCamera()async{
    final coordinates = new Coordinates(this.latitude, this.longitude);
    final addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    this.selectedAddress = addresses.first;
    notifyListeners();
    print("${selectedAddress.featureName} : ${selectedAddress.addressLine}");
  }

  //save preference
  Future<void>savePrefs()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', this.longitude);
    prefs.setDouble('longitude', this.longitude);
    prefs.setString('address', this.selectedAddress.addressLine);
    prefs.setString('location', this.selectedAddress.featureName);
  }

}