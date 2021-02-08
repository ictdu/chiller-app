import 'package:chiller_app/providers/auth_provider.dart';
import 'package:chiller_app/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home-screen';
  //when the user logged in successfully, this will be the screen.
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: Container(),
        title: FlatButton(
          onPressed: (){

          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Delivery Address',
                  style: TextStyle(
                    color: Colors.white,
                  ),),
              Icon(
                Icons.edit_outlined,
                color: Colors.white,),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
                icon: Icon(Icons.account_circle_outlined),
                onPressed: (){

                },
            ),
          ),
        ],
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: Colors.grey,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none
                ),
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: Colors.white,

              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
