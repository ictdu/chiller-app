import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:chiller_admin/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final _formKey = GlobalKey<FormState>();
  FirebaseServices _services = FirebaseServices();
  String username;
  String password;

  @override
  Widget build(BuildContext context) {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Theme.of(context).primaryColor,
        animationDuration: Duration(milliseconds: 500)
    );

    Future<void>_login()async{
      progressDialog.show();
      _services.getAdminCredentials().then((value){
        value.docs.forEach((doc) async {
          if(doc.get('username')==username){
            if(doc.get('password')==password){
              UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
              progressDialog.dismiss();
              if(userCredential.user.uid != null){
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
                return;
              }else{
                _showMyDialog(
                    title: 'Login',
                    message: 'Login Failed.'
                );
              }
            }else{
              progressDialog.dismiss();
              _showMyDialog(
                  title: 'Incorrect Password',
                  message: 'The password you have entered is incorrect.'
              );
            }
          }else{
            progressDialog.dismiss();
            _showMyDialog(
                title: 'Invalid Username',
                message: 'The username you have entered is invalid.'
            );
          }
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(widget.title, style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Center(child: Text('Connection Failed'),);
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Colors.white
                  ],
                  stops: [1.0, 1.0], //half screen color
                  //stops: [0.8, 8.0],
                  begin: Alignment.topCenter,
                  end: Alignment(0.0,0.0),
                ),
              ),
              child: Center(
                child: Container(
                  width: 300,
                  height: 400,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Image.asset('images/logo.png', height: 100, width: 100,),
                                  Text('CHILLER APP ADMIN', style:
                                  TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20
                                  ),),
                                  SizedBox(height: 21,),
                                  TextFormField(
                                    validator: (value){
                                      if(value.isEmpty){
                                        return 'Please enter your username.';
                                      }
                                      setState(() {
                                        username = value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.person),
                                      labelText: 'Username',
                                      contentPadding: EdgeInsets.only(left: 20, right: 20),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12,),
                                  TextFormField(
                                    validator: (value){
                                      if(value.isEmpty){
                                        return 'Please enter your password.';
                                      }
                                      if(value.length<6){
                                        return 'Password must be at least 6 \ncharacters.';
                                      }
                                      setState(() {
                                        password = value;
                                      });
                                      return null;
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.vpn_key_sharp),
                                      labelText: 'Password',
                                      contentPadding: EdgeInsets.only(left: 20, right: 20),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12,),
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                      onPressed: ()async{
                                        if(_formKey.currentState.validate()){
                                          _login();
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        primary: Colors.white,
                                        backgroundColor: Theme.of(context).primaryColor,
                                      ),
                                      child: Text('Login')),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<void> _showMyDialog({title, message}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
                Text('Please try again.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}