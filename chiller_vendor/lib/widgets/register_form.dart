import 'dart:io';

import 'package:chiller_vendor/providers/auth_provider.dart';
import 'package:chiller_vendor/screens/home_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _passwordController = TextEditingController();
  var _confirmPassController = TextEditingController();
  var _addressTextController = TextEditingController();
  var _nameTextController = TextEditingController();
  var _dialogTextController = TextEditingController();
  String email;
  String password;
  String mobile;
  String shopName;
  bool _isLoading = false;

  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String>uploadFile(filePath) async {
    File file = File(filePath);

    try {
      await _storage.ref('uploads/shopProfilePic/${_nameTextController.text}').putFile(file);
    } on FirebaseException catch (e) {
      print (e.code);
    }
    //file url path to save in database
    String downloadURL = await _storage.ref('uploads/shopProfilePic/${_nameTextController.text}').getDownloadURL();
    return downloadURL;
  }


  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    scaffoldMessage(message){
      return Scaffold
          .of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    return _isLoading ? CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    ) : Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              validator: (value){
                if(value.isEmpty){
                  return 'Enter Shop Name';
                }
                setState(() {
                  _nameTextController.text = value;
                });
                setState(() {
                  shopName = value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.add_business),
                labelText: 'Store Name',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).primaryColor
                  )
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              maxLength: 10,
              validator: (value){
                if(value.isEmpty){
                  return 'Enter Mobile Number';
                }
                setState(() {
                  mobile = value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixText: '+63',
                prefixIcon: Icon(Icons.phone_android),
                labelText: 'Mobile Number',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).primaryColor
                    )
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              controller: _emailTextController,
              keyboardType: TextInputType.emailAddress,
              validator: (value){
                if(value.isEmpty){
                  return 'Enter Email';
                }
                final bool _isValid = EmailValidator.validate(_emailTextController.text);
                if(!_isValid){
                  return 'Invalid Email Format';
                }
                setState(() {
                  email = value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: 'Email',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).primaryColor
                    )
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              obscureText: true,
              validator: (value){
                if(value.isEmpty){
                  return 'Enter Password';
                }
                if(value.length<6){
                  return 'Password must be at least 6 characters';
                }
                setState(() {
                  password = value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key_outlined),
                labelText: 'Password',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).primaryColor
                    )
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              obscureText: true,
              validator: (value){
                if(value.isEmpty){
                  return 'Re-enter Password';
                }
                if(_passwordController.text != _confirmPassController.text){
                  return 'Password doesn\'t match';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key_outlined),
                labelText: 'Confirm Password',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).primaryColor
                    )
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              maxLines: 5,
              controller: _addressTextController,
              validator: (value){
                if(value.isEmpty){
                  return 'Please press the navigation button';
                }
                if(_authData.shopLatitude == null){
                  return 'Please press the navigation button';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.contact_mail_outlined),
                labelText: 'Store Location',
                suffixIcon: IconButton(
                  icon: Icon(Icons.location_searching),
                  onPressed: (){
                    _addressTextController.text = 'Locating...\nPlease wait...';
                    _authData.getCurrentAddress().then((address) => {
                      if(address!=null){
                        setState((){
                          _addressTextController.text = '${_authData.placeName}\n${_authData.shopAddress}';
                        })
                      }else{
                        Scaffold
                        .of(context)
                        .showSnackBar(SnackBar(content: Text('Could not find location. Try again.')))
                      }
                    });
                  },
                ),
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).primaryColor
                    )
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              onChanged: (value){
                _dialogTextController.text = value;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.comment),
                labelText: 'Shop Dialog',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).primaryColor
                    )
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                    onPressed: (){
                    if(_authData.isPicAvail == true){ //first it will validate profile picture
                      if(_formKey.currentState.validate()){ //then it will validate form
                        setState(() {
                          _isLoading = true;
                        });
                        _authData.registerVendor(email, password).then((credential){
                          if(credential.user.uid != null){
                            uploadFile(_authData.image.path).then((url) {
                              if(url != null){
                                //save vendor details to database
                                _authData.savedVendorDataToDb(
                                  url: url,
                                  mobile: mobile,
                                  shopName: shopName,
                                  dialog: _dialogTextController.text,
                                );
                                  setState(() {
                                    _formKey.currentState;
                                    _isLoading = false;
                                  });
                                  Navigator.pushReplacementNamed(context, HomeScreen.id);
                                //navigate to homescreen after finishing all the process
                              }else{
                                scaffoldMessage('Failed to upload shop profile image');
                              }
                            });

                          }else{
                            //registration failed
                            scaffoldMessage(_authData.error);
                          }
                        });
                      }
                    }else{
                      scaffoldMessage('Shop profile picture is needed.');
                    }

                    },
                    child: Text('Register',
                    style: TextStyle(
                      color: Colors.white,
                    ),),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
