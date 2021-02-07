import 'package:chiller_app/providers/auth_provider.dart';
import 'package:chiller_app/providers/location_provider.dart';
import 'package:chiller_app/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'loginin-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _validPhoneNumber = false;
  var _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: auth.error=='Invalid OTP'? true:false,
                  child: Container(
                    child: Column(
                      children: [
                        Text(auth.error,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),),
                        SizedBox(height: 5,),
                      ],
                    ),
                  ),
                ),
                Text('LOGIN',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                Text('Enter your mobile number to proceed',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),),
                SizedBox(height: 20,),
                TextField(
                  decoration: InputDecoration(
                    prefixText: '+63 ',
                    labelText: '10 digits mobile number',
                  ),
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  controller: _phoneNumberController,
                  onChanged: (value){
                    if(value.length==10){
                      setState ((){
                        _validPhoneNumber = true;
                      });
                    } else {
                      setState ((){
                        _validPhoneNumber = false;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AbsorbPointer(
                        absorbing: _validPhoneNumber ? false:true,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom
                          ),
                          child: FlatButton(
                            onPressed: (){
                              setState((){
                                auth.loading = true;
                                auth.screen = 'MapScreen';
                                auth.latitude = locationData.latitude;
                                auth.longitude = locationData.longitude;
                                auth.address = locationData.selectedAddress.addressLine;

                              });
                              String number = '+63${_phoneNumberController.text}';
                              auth.verifyPhone(
                                context: context,
                                number: number,
                                ).then((value){
                                _phoneNumberController.clear();
                                setState(() {
                                  auth.loading = false;
                                });
                              });
                            },
                            color: _validPhoneNumber ? Theme.of(context).primaryColor : Colors.grey,
                            child: auth.loading ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ) : Text(_validPhoneNumber ? 'CONTINUE' : 'ENTER MOBILE NUMBER',
                              style: TextStyle(
                                color: Colors.white,
                              ),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ),
        ),
    );
  }
}
