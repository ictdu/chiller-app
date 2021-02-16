import 'package:chiller_vendor/providers/auth_provider.dart';
import 'package:chiller_vendor/screens/login_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  static const String id = 'reset-screen';
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  String email;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('images/forgotpass.gif',
                      height: 250,),
                  SizedBox(height: 25,),
                  RichText(text: TextSpan(
                    text: '',
                    children: [
                      TextSpan(
                          text: 'Forgot Password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                          text: '\nEnter your registered email to receive a password reset link.',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ]
                  ),),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: _emailTextController,
                    validator: (value){
                      if(value.isEmpty){
                        return 'Enter email';
                      }
                      final bool _isValid = EmailValidator.validate(_emailTextController.text);
                      if(!_isValid){
                        return 'Invalid email format';
                      }
                      setState(() {
                        email = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      contentPadding: EdgeInsets.zero,
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                          onPressed: (){
                            if(_formKey.currentState.validate()){
                              setState(() {
                                _loading = true;
                              });
                              _authData.resetPassword(email);
                              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Password reset link has been sent to your email.')));
                            }
                            Navigator.pushReplacementNamed(context, LoginScreen.id);
                          },
                            color: Theme.of(context).primaryColor,
                            child: _loading ? LinearProgressIndicator() : Text('Reset Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pushReplacementNamed(context, LoginScreen.id);
                        },
                        child: Text('Login', textAlign: TextAlign.center, style:
                        TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
