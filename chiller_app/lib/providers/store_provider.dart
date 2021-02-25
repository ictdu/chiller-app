import 'package:chiller_app/screens/welcome_screen.dart';
import 'package:chiller_app/services/store_services.dart';
import 'package:chiller_app/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class StoreProvider with ChangeNotifier{
  StoreServices _storeServices = StoreServices();
  UserServices _userServices = UserServices();
  User user = FirebaseAuth.instance.currentUser;
  var userLatitude = 0.0;
  var userLongitude = 0.0;

  Future<void>getUserLocationData(context)async{
    _userServices.getUserById(user.uid).then((result){
        if (user != null) {
            userLatitude = result.data()['latitude'];
            userLongitude = result.data()['longitude'];
            notifyListeners();
        } else {
          Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        }
      });
  }

}