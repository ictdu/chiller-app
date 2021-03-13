import 'dart:html';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:chiller_admin/services/firebase_services.dart';
import 'package:chiller_admin/widgets/banner_widget.dart';
import 'package:chiller_admin/widgets/sidebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:firebase/firebase.dart' as fb;

class BannerScreen extends StatefulWidget {
  static const String id = 'banner-screen';

  @override
  _BannerScreenState createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  SideBarWidget _sideBar = SideBarWidget();
  FirebaseServices _services = FirebaseServices();
  var _fileNameTextController = TextEditingController();
  bool _visible = false;
  bool _imageSelected = true;
  String _url;

  @override
  Widget build(BuildContext context) {

    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(.3),
        animationDuration: Duration(milliseconds: 500)
    );

    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: const Text('Chiller Admin Dashboard',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      sideBar: _sideBar.sideBarMenus(context, BannerScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit/Add/Delete Banner',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36
                ),
              ),
              Text('Add / Delete Home Screen Banner Images'),
              Divider(
                thickness: 5,
              ),
              //Banners
              BannerWidget(),
              Divider(
                thickness: 5,
              ),
              Container(
                color: Colors.grey,
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Row(
                    children: [
                      Visibility(
                        visible: _visible,
                        child: Container(
                          child: Row(
                            children: [
                              AbsorbPointer(
                                absorbing: true,
                                child: SizedBox(
                                  width: 300,
                                  height: 30,
                                  child: TextField(
                                    controller: _fileNameTextController,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'No image selected',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.only(left: 20)
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              TextButton(
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text('Select Image',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: (){
                                  uploadStorage();
                                },
                                style: TextButton.styleFrom(backgroundColor: Colors.black54),
                              ),
                              SizedBox(width: 10,),
                              AbsorbPointer(
                                absorbing: _imageSelected,
                                child: TextButton(
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text('Upload Image',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  onPressed: (){
                                    progressDialog.show();
                                    _services.uploadBannerImageToDb(_url).then((downloadUrl){
                                      if(downloadUrl != null){
                                        progressDialog.dismiss();
                                        _services.showMyDialog(
                                          title: 'New Banner Image',
                                          message: 'The image banner was saved successfully.',
                                          context: context
                                        );
                                      }
                                    });
                                  },
                                  style: _imageSelected ? TextButton.styleFrom(backgroundColor: Colors.black12) : TextButton.styleFrom(backgroundColor: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Visibility(
                        visible: _visible ? false : true,
                        child: TextButton(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text('Add New Banner',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: (){
                            setState(() {
                              _visible = true;
                            });
                          },
                          style: TextButton.styleFrom(backgroundColor: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //select image
  void uploadImage({@required Function(File file) onSelected}){
    InputElement uploadInput = FileUploadInputElement()..accept='image/*'; //it will be only upload image
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final file = uploadInput.files.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
      });
    });
  }

  //upload selected image to firebase storage
  void uploadStorage(){
    final dateTime = DateTime.now();
    final path = 'bannerImage/$dateTime';
    uploadImage(onSelected: (file){
      if(file != null){
        setState(() {
          _fileNameTextController.text = file.name;
          _imageSelected = false;
          _url = path;
        });
        fb.storage().refFromURL('gs://chiller-store.appspot.com').child(path).put(file);
      }
    });
  }

}
