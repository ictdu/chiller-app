import 'package:chiller_app/providers/auth_provider.dart';
import 'package:chiller_app/screens/welcome_screen.dart';
import 'package:chiller_app/widgets/image_slider.dart';
import 'package:chiller_app/widgets/my_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(112),
        child: MyAppBar(),
      ),
      body: Center(
        child: Column(
          children: [
            ImageSlider(),
            RaisedButton(
              onPressed: (){
                auth.error='';
                FirebaseAuth.instance.signOut().then((value){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>WelcomeScreen(),
                  ));
                });
              },
              child: Text('Sign Out',
                style: TextStyle(
                  color: Colors.black,
                ),),
            ),
            RaisedButton(
              onPressed: (){
                Navigator.pushNamed(context, WelcomeScreen.id);
              },
              child: Text('Home Screen',
                style: TextStyle(
                  color: Colors.black,
                ),),
            ),
          ],
        ),
      ),
    );
  }
}
