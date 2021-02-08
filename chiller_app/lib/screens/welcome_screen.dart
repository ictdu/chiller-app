import 'package:chiller_app/providers/auth_provider.dart';
import 'package:chiller_app/providers/location_provider.dart';
import 'package:chiller_app/screens/map_screen.dart';
import 'package:chiller_app/screens/onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome-screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthProvider>(context);

    bool _validPhoneNumber = false;
    var _phoneNumberController = TextEditingController();

    //this is the bottom screen when you click 'Login'
    void showBottomSheet(context){
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))
        ),
        context: context,
        isScrollControlled: true,
        builder: (context)=> StatefulBuilder(
          builder: (context, StateSetter myState){
            return Container(
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
                          myState ((){
                            _validPhoneNumber = true;
                          });
                        } else {
                          myState ((){
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
                                  myState((){
                                    auth.loading = true;
                                    auth.screen = 'MapScreen';
                                  });
                                  String number = '+63${_phoneNumberController.text}';
                                  //no location data here. Default value is null
                                  auth.verifyPhone(
                                    context: context,
                                    number: number,
                                  ).then((value){
                                    _phoneNumberController.clear();
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
            );
          },
        ),
      ).whenComplete(() {
        setState(() {
          auth.loading = false;
          _phoneNumberController.clear();
        });
      });
    }

    final locationData = Provider.of<LocationProvider>(context,listen: false);

    //this will be in the main screen after the splashscreen
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            //this one is supposed to display SKIP text (option)
            //on the upper-right corner of the screen
            //but I can't make it work.
            Positioned(
              right: 0.0,
              top: 10.0,
              child: FlatButton(
                child: Text(
                  'SKIP',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {},
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: OnBoardScreen(),
                ),
                Text(
                  'Are you ready to make an order?',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  color: Colors.blue,
                  child: locationData.loading ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ) : Text(
                    'SET DELIVERY LOCATION',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async{
                    setState(() {
                      locationData.loading = true;
                    });
                    await locationData.getCurrentPosition();
                    if(locationData.permissionAllowed==true){
                      Navigator.pushReplacementNamed(context, MapScreen.id);
                      setState(() {
                        locationData.loading = false;
                      });
                    }else{
                      print('Permission is not allowed');
                      setState(() {
                        locationData.loading = false;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 0,
                ),
                FlatButton(
                  child: RichText(
                    text: TextSpan(
                        text: 'Already a customer? ',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                        children: [
                          TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ))
                        ]),
                  ),
                  onPressed: () {
                    setState(() {
                      auth.screen = 'Login';
                    });
                    showBottomSheet(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
