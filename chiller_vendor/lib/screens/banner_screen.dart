import 'dart:io';

import 'package:chiller_vendor/providers/product_provider.dart';
import 'package:chiller_vendor/services/firebase_services.dart';
import 'package:chiller_vendor/widgets/banner_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class BannerScreen extends StatefulWidget {
  @override
  _BannerScreenState createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  FirebaseServices _services = FirebaseServices();
  bool _visible = false;
  File _image;
  var _imagePathText = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var _provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          BannerCard(),
          Divider(thickness: 3,),
          SizedBox(height: 20,),
          Container(
            child: Center(
              child: Text('ADD NEW BANNER',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.grey[200],
                      child: _image != null ? Image.file(_image, fit: BoxFit.fill,) : Center(child: Text('No Image Selected'),),
                    ),
                  ),
                  TextFormField(
                    controller: _imagePathText,
                    enabled: false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 20,),
                  Visibility(
                    visible: _visible ? false : true,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),),
                            child: Text('Add New Banner',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: (){
                              setState(() {
                                _visible = true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _visible,
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),),
                                  child: Text('Upload Image',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: (){
                                    getBannerImage().then((value){
                                      if(_image != null){
                                        _imagePathText.text = _image.path;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: AbsorbPointer(
                                  absorbing: _image != null ? false : true,
                                  child: TextButton(
                                    style: ButtonStyle(backgroundColor: _image != null? MaterialStateProperty.all(Theme.of(context).primaryColor) : MaterialStateProperty.all(Colors.grey),),
                                    child: Text('Save',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: (){
                                      EasyLoading.show(status: 'Saving...');
                                      uploadBannerImage(_image.path, _provider.shopName).then((url){
                                        if(url != null){
                                          _services.saveBanner(url);
                                          setState(() {
                                            _imagePathText.clear();
                                            _image = null;
                                          });
                                          EasyLoading.dismiss();
                                          _provider.alertDialog(
                                            context: context,
                                            title: 'Banner Upload',
                                            content: 'The banner image is uploaded successfully',
                                          );
                                        }else{
                                          EasyLoading.dismiss();
                                          _provider.alertDialog(
                                            context: context,
                                            title: 'Banner Upload',
                                            content: 'The banner image upload is failed',
                                          );
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black54),),
                                  child: Text('Cancel',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: (){
                                    setState(() {
                                      _visible = false;
                                      _imagePathText.clear();
                                      _image = null;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<File> getBannerImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 20); //reduce image size
    if (pickedFile != null){
      setState(() {
        _image = File(pickedFile.path);
      });
    }else{
      print('No image selected.');
    }
    return _image;
  }

  Future<String>uploadBannerImage(filePath, shopName) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;

    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage.ref('vendorbanner/${shopName}/$timeStamp').putFile(file);
    } on FirebaseException catch (e) {
      print (e.code);
    }
    //file url path to save in database
    String downloadURL = await _storage.ref('vendorbanner/${shopName}/$timeStamp').getDownloadURL();
    return downloadURL;
  }
}
