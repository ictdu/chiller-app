import 'package:chiller_vendor/screens/login_screen.dart';
import 'package:chiller_vendor/widgets/image_picker.dart';
import 'package:chiller_vendor/widgets/register_form.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  static const String id = 'register-screen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  ShopPicCard(),
                  RegisterForm(),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pushReplacementNamed(context, LoginScreen.id);
                        },
                        child: Text('Already have an account? Login here.', textAlign: TextAlign.center, style:
                        TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
