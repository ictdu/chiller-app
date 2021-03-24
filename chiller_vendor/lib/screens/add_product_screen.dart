import 'package:chiller_vendor/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AddNewProduct extends StatelessWidget {
  static const String id = 'addnewproduct-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: Icon(Icons.arrow_back_outlined, color: Colors.black54,),
          onPressed: (){
            Navigator.pushReplacementNamed(context, HomeScreen.id);
          },
        ),
      ),
      body: Column(
        children: [
          Material(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      child: Text('Products / Add'),
                    ),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    icon: Icon(Icons.save, color: Colors.white,),
                    label: Text('Save', style: TextStyle(
                        color: Colors.white
                    ),),
                    onPressed: (){},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
