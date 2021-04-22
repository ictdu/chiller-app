import 'dart:io';

import 'package:chiller_vendor/providers/product_provider.dart';
import 'package:chiller_vendor/services/firebase_services.dart';
import 'package:chiller_vendor/widgets/category_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class EditViewProduct extends StatefulWidget {
  final String productId;
  EditViewProduct({this.productId});
  @override
  _EditViewProductState createState() => _EditViewProductState();
}

class _EditViewProductState extends State<EditViewProduct> {

  FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();

  List<String> _collections = [
    'Featured Products',
    'Best Selling',
    'Recently Added'
  ];
  String dropdownValue;

  var _brandTextController = TextEditingController();
  var _skuTextController = TextEditingController();
  var _productNameTextController = TextEditingController();
  var _weightTextController = TextEditingController();
  var _priceTextController = TextEditingController();
  var _comparedPriceTextController = TextEditingController();
  var _descriptionTextController = TextEditingController();
  var _categoryTextController = TextEditingController();
  var _subCategoryTextController = TextEditingController();
  var _stockTextController = TextEditingController();
  var _lowStockTextController = TextEditingController();
  var _taxTextController = TextEditingController();
  DocumentSnapshot doc;
  double discount;
  String image;
  String categoryImage;
  File _image;
  bool _visible = false;
  bool _editing = true;

  @override
  void initState() {
    getProductDetails();
    super.initState();
  }

  Future<void>getProductDetails()async{
    _services.products.doc(widget.productId).get().then((DocumentSnapshot document){
      if(document.exists){
        setState(() {
          doc = document;
          _brandTextController.text = document.data()['brand'];
          _skuTextController.text = document.data()['sku'];
          _productNameTextController.text = document.data()['productName'];
          _weightTextController.text = document.data()['weight'];
          _priceTextController.text = document.data()['price'].toString();
          _comparedPriceTextController.text = document.data()['comparedPrice'].toString();
          var difference = double.parse(_comparedPriceTextController.text) - double.parse(_priceTextController.text);
          discount = (difference / double.parse(_comparedPriceTextController.text) * 100);
          image = document.data()['productImage'];
          _descriptionTextController.text = document.data()['description'];
          _categoryTextController.text = document.data()['category']['mainCategory'];
          _subCategoryTextController.text = document.data()['category']['subCategory'];
          dropdownValue = document.data()['collection'];
          _stockTextController.text = document.data()['stockQty'].toString();
          _lowStockTextController.text = document.data()['lowStockQty'].toString();
          _taxTextController.text = document.data()['tax'].toString();
          categoryImage = document.data()['categoryImage'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    _provider.resetProvider();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        actions: [
          TextButton(
            child: Text('Edit', style: TextStyle(color: Colors.white),),
            onPressed: (){
              setState(() {
                _editing = false;
              });
            },
          ),
        ],
      ),
      bottomSheet: Container(
        height: 60,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Text('Cancel',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: AbsorbPointer(
                absorbing: _editing,
                child: InkWell(
                  onTap: (){
                    if(_formKey.currentState.validate()){
                      EasyLoading.show(status: 'Saving...');
                      if(_image != null){
                        _provider.uploadProductImage(_image.path, _productNameTextController.text).then((url){
                          if(url != null){
                            EasyLoading.dismiss();
                            _provider.updateProduct(
                              context: context,
                              brand: _brandTextController.text,
                              sku: _skuTextController.text,
                              productName:  _productNameTextController.text,
                              weight: _weightTextController.text,
                              price: double.parse(_priceTextController.text),
                              comparedPrice: double.parse(_comparedPriceTextController.text),
                              image: image,
                              description: _descriptionTextController.text,
                              category: _categoryTextController.text,
                              subCategory: _subCategoryTextController.text,
                              categoryImage: categoryImage,
                              collection: dropdownValue,
                              stockQty: int.parse(_stockTextController.text),
                              lowStockQty: int.parse(_lowStockTextController.text),
                              tax: double.parse(_taxTextController.text),
                              productId: widget.productId,
                            );
                          }
                        });
                      }else{
                        _provider.updateProduct(
                          context: context,
                          brand: _brandTextController.text,
                          sku: _skuTextController.text,
                          productName:  _productNameTextController.text,
                          weight: _weightTextController.text,
                          price: double.parse(_priceTextController.text),
                          comparedPrice: double.parse(_comparedPriceTextController.text),
                          image: image,
                          description: _descriptionTextController.text,
                          category: _categoryTextController.text,
                          subCategory: _subCategoryTextController.text,
                          categoryImage: categoryImage,
                          collection: dropdownValue,
                          stockQty: int.parse(_stockTextController.text),
                          lowStockQty: int.parse(_lowStockTextController.text),
                          tax: double.parse(_taxTextController.text),
                          productId: widget.productId,
                        );
                        EasyLoading.dismiss();
                      }
                    }
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  child: Container(
                    child: AbsorbPointer(
                      absorbing: _editing,
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        child: Center(
                          child: Text('Save',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: doc == null ? Center(child: CircularProgressIndicator()) : Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              AbsorbPointer(
                absorbing: _editing,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 80,
                          height: 30,
                          child: TextFormField(
                            controller: _brandTextController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10, right: 10),
                              hintText: 'Brand',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Theme.of(context).primaryColor.withOpacity(.1),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('SKU: '),
                            Container(
                              width: 50,
                              child: TextFormField(
                                controller: _skuTextController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none
                        ),
                        controller: _productNameTextController,
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: TextFormField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none
                        ),
                        controller: _weightTextController,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 100,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                  prefixText: 'PHP ',
                              ),
                              controller: _priceTextController,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            child: TextFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                prefixText: 'PHP ',
                              ),
                              controller: _comparedPriceTextController,
                              style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.lineThrough
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8),
                                child: Text('${discount.toStringAsFixed(0)}% OFF',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: Text('Inclusive of all taxes',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        _provider.getProductImage().then((image){
                          setState(() {
                            _image = image;
                          });
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _image != null ? Center(child: Image.file(_image, width: 250,)) : Center(child: Image.network(image, height: 250,)),
                      ),
                    ),
                    Text('About this product', style: TextStyle(fontSize: 20),),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                        maxLines: null,
                        controller: _descriptionTextController,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Row(
                        children: [
                          Text('Category',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: AbsorbPointer(
                              absorbing: true, //this will block entering category name manually
                              child: TextFormField(
                                controller: _categoryTextController,
                                validator: (value){
                                  if(value.isEmpty){
                                    return 'Select category name';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'not selected',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _editing ? false : true,
                            child: IconButton(
                              icon: Icon(Icons.edit_outlined),
                              onPressed: (){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      return CategoryList();
                                    }
                                ).whenComplete((){
                                  setState(() {
                                    _categoryTextController.text = _provider.selectedCategory;
                                    _visible = true;
                                  });
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _visible,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        child: Row(
                          children: [
                            Text('Sub Category',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: AbsorbPointer(
                                absorbing: true, //this will block entering subcategory name manually
                                child: TextFormField(
                                  controller: _subCategoryTextController,validator: (value){
                                  if(value.isEmpty){
                                    return 'Select subcategory name';
                                  }
                                  return null;
                                },
                                  decoration: InputDecoration(
                                    hintText: 'not selected',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit_outlined),
                              onPressed: (){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      return SubCategoryList();
                                    }
                                ).whenComplete((){
                                  setState(() {
                                    _subCategoryTextController.text = _provider.selectedSubCategory;
                                  });
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text('Collection',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(width: 10,),
                          DropdownButton<String>(
                            hint: Text('Select Collection'),
                            value: dropdownValue,
                            icon: Icon(Icons.arrow_drop_down),
                            onChanged: (String value){
                              setState(() {
                                dropdownValue = value;
                              });
                            },
                            items: _collections.map<DropdownMenuItem<String>>((String value){
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text('Stock: '),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none
                            ),
                            controller: _stockTextController,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Low Stock: '),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none
                            ),
                            controller: _lowStockTextController,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Tax %: '),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none
                            ),
                            controller: _taxTextController,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 60,),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
