import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:chiller_admin/screens/home_screen.dart';
import 'package:chiller_admin/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final _formKey = GlobalKey<FormState>();
  FirebaseServices _services = FirebaseServices();
  var _usernameTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(.3),
        animationDuration: Duration(milliseconds: 500)
    );

    _login({username, password})async{
      progressDialog.show();
      _services.getAdminCredentials(username).then((value) async {
        if(value.exists){
          if(value.data()['username'] == username){
            if(value.data()['password'] == password){
              //if username and password are correct
              try{
                UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
                if(userCredential!=null){
                  //if signed-in successfully, navigate to homescreen
                  progressDialog.dismiss();
                  Navigator.pushReplacementNamed(context, HomeScreen.id);
                }
              }catch(e){
                //if signing-in is failed
                progressDialog.dismiss();
                _showMyDialog(
                    title: 'Login',
                    message: '${e.toString()}'
                );
              }
              return;
            }
            //if password is incorrect
            progressDialog.dismiss();
            _showMyDialog(
                title: 'Incorrect Password',
                message: 'The password you have entered is incorrect.'
            );
            return;
          }
          //if username is incorrect
          progressDialog.dismiss();
          _showMyDialog(
            title: 'Invalid Username',
            message: 'The username you have entered is invalid.'
          );
        }
        progressDialog.dismiss();
        _showMyDialog(
            title: 'Invalid Username',
            message: 'The username you have entered is invalid.'
        );
      });
    }

    return Scaffold(
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
                                  Text('CHILLER ADMIN', style:
                                  TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20
                                  ),),
                                  SizedBox(height: 21,),
                                  TextFormField(
                                    controller: _usernameTextController,
                                    validator: (value){
                                      if(value.isEmpty){
                                        return 'Please enter your username.';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.person),
                                      labelText: 'Username',
                                      contentPadding: EdgeInsets.only(left: 20),
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
                                    controller: _passwordTextController,
                                    validator: (value){
                                      if(value.isEmpty){
                                        return 'Please enter your password.';
                                      }
                                      if(value.length<6){
                                        return 'Password must be at least 6 \ncharacters.';
                                      }
                                      return null;
                                    },
                                    obscureText: _visible == false ? true : false,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: _visible ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                                        onPressed: (){
                                          setState(() {
                                            _visible = !_visible;
                                          });
                                        },
                                      ),
                                      prefixIcon: Icon(Icons.vpn_key_sharp),
                                      labelText: 'Password',
                                      contentPadding: EdgeInsets.only(left: 20),
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
                                          _login(
                                            username: _usernameTextController.text,
                                            password: _passwordTextController.text,
                                          );
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