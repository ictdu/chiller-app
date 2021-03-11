import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chiller App Admin Panel',
      theme: ThemeData(
        primarySwatch: Theme.of(context).primaryColor,
      ),
      home: MyHomePage(title: 'Chiller App Admin Panel'),
        debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(widget.title, style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Container(
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
                                return null;
                              },
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
                                onPressed: (){
                                  if(_formKey.currentState.validate()){
                                    print('Validated');
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
      ),
    );
  }
}
