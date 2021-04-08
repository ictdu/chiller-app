import 'dart:io';

import 'package:chiller_vendor/providers/product_provider.dart';
import 'package:chiller_vendor/screens/home_screen.dart';
import 'package:chiller_vendor/widgets/category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class AddNewProduct extends StatefulWidget {
  static const String id = 'addnewproduct-screen';

  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {

  final _formKey = GlobalKey<FormState>();
  List<String> _collections = [
    'Featured Products',
    'Best Selling',
    'Recently Added'
  ];
  String dropdownValue;

  var _categoryTextController = TextEditingController();
  var _subCategoryTextController = TextEditingController();
  var _comparedPriceController = TextEditingController();
  var _brandTextController = TextEditingController();
  var _taxTextController = TextEditingController();
  var _stockTextController = TextEditingController();
  var _lowStockTextController = TextEditingController();
  File _image;
  bool _visible = false;
  bool _track = false;

  String productName;
  String description;
  double price;
  double comparedPrice;
  String sku;
  String weight;
  double tax;

  @override
  Widget build(BuildContext context) {

    var _provider = Provider.of<ProductProvider>(context);

    return DefaultTabController(
      length: 2,
      initialIndex: 1, //will keep initial index 1 to avoid textfield clearing automatically
      child: Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: Icon(Icons.arrow_back_outlined, color: Colors.black54,),
            onPressed: (){
              Navigator.pushReplacementNamed(context, HomeScreen.id);
            },
          ),
        ),
        body: Form(
          key: _formKey,
          child: Column(
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
                        onPressed: (){
                          if(_formKey.currentState.validate()){ //only if filled necessary fields
                            if(_categoryTextController.text.isNotEmpty){
                              if(_subCategoryTextController.text.isNotEmpty){
                                if(_image != null){
                                  //image should be selected
                                  //upload image to storage
                                  EasyLoading.show(status: 'Saving...');
                                  _provider.uploadProductImage(_image.path, productName).then((url){
                                    if(url != null){
                                      //upload product data to firestore
                                      EasyLoading.dismiss();
                                      _provider.saveProductDatatoDb(
                                        context: context,
                                        productName: productName,
                                        description: description,
                                        price: price,
                                        comparedPrice: double.parse(_comparedPriceController.text),
                                        collection: dropdownValue,
                                        brand: _brandTextController.text,
                                        sku: sku,
                                        weight: weight,
                                        tax: double.parse(_taxTextController.text),
                                        stockQty: int.parse(_stockTextController.text),
                                        lowStockQty: int.parse(_lowStockTextController.text),
                                      );
                                      setState(() {
                                        _formKey.currentState.reset();
                                      });
                                    }else{
                                      //upload failed
                                      _provider.alertDialog(
                                        context: context,
                                        title: 'IMAGE UPLOAD',
                                        content: 'Failed to upload product image',
                                      );
                                    }
                                  });
                                }else{
                                  //image not selected
                                  _provider.alertDialog(
                                    context: context,
                                    title: 'PRODUCT IMAGE',
                                    content: 'Product image is not selected',
                                  );
                                }
                              }else{
                                _provider.alertDialog(
                                  context: context,
                                  title: 'Main Sub Category',
                                  content: 'Sub category is not selected',
                                );
                              }
                            }else{
                              _provider.alertDialog(
                                context: context,
                                title: 'Main Category',
                                content: 'Main category is not selected',
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(text: 'GENERAL',),
                  Tab(text: 'INVENTORY',),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: TabBarView(
                      children: [
                       ListView(
                         children: [
                           Padding(
                             padding: const EdgeInsets.all(10.0),
                             child: Column(
                               children: [
                                 TextFormField(
                                   validator: (value){
                                     if(value.isEmpty){
                                       return 'Enter product name';
                                     }
                                     setState(() {
                                       productName = value;
                                     });
                                     return null;
                                   },
                                   decoration: InputDecoration(
                                     labelText: 'Product Name*',
                                     labelStyle: TextStyle(color: Colors.grey),
                                     enabledBorder: UnderlineInputBorder(
                                       borderSide: BorderSide(
                                         color: Colors.grey[300],
                                       ),
                                     ),
                                   ),
                                 ),
                                 TextFormField(
                                   keyboardType: TextInputType.multiline,
                                   maxLines: 5,
                                   maxLength: 500,
                                   validator: (value){
                                     if(value.isEmpty){
                                       return 'Enter description';
                                     }
                                     setState(() {
                                       description = value;
                                     });
                                     return null;
                                   },
                                   decoration: InputDecoration(
                                     labelText: 'About Product*',
                                     labelStyle: TextStyle(color: Colors.grey),
                                     enabledBorder: UnderlineInputBorder(
                                       borderSide: BorderSide(
                                         color: Colors.grey[300],
                                       ),
                                     ),
                                   ),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: InkWell(
                                     onTap: (){
                                       _provider.getProductImage().then((image){
                                         setState(() {
                                           _image = image;
                                         });
                                       });
                                     },
                                     child: SizedBox(
                                       width: 150,
                                       height: 150,
                                       child: Card(
                                         child: Center(
                                           child: _image == null ? Text('Select Image') : Image.file(_image),
                                         ),
                                       ),
                                     ),
                                   ),
                                 ),
                                 TextFormField(
                                   validator: (value){
                                     if(value.isEmpty){
                                       return 'Enter selling price';
                                     }
                                     setState(() {
                                       price = double.parse(value);
                                     });
                                     return null;
                                   },
                                   keyboardType: TextInputType.number,
                                   decoration: InputDecoration(
                                     labelText: 'Price*', //final selling price
                                     labelStyle: TextStyle(color: Colors.grey),
                                     enabledBorder: UnderlineInputBorder(
                                       borderSide: BorderSide(
                                         color: Colors.grey[300],
                                       ),
                                     ),
                                   ),
                                 ),
                                 TextFormField(
                                   controller: _comparedPriceController,
                                   validator: (value){
                                     //compared price is not required
                                     if(price>double.parse(value)){ //compared price must be always higher than selling price
                                       return 'Compared price should be higher than price';
                                     }
                                     return null;
                                   },
                                   keyboardType: TextInputType.number,
                                   decoration: InputDecoration(
                                     labelText: 'Compared Price', //price before discount
                                     labelStyle: TextStyle(color: Colors.grey),
                                     enabledBorder: UnderlineInputBorder(
                                       borderSide: BorderSide(
                                         color: Colors.grey[300],
                                       ),
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
                                 TextFormField(
                                   controller: _brandTextController,
                                   //not required
                                   decoration: InputDecoration(
                                     labelText: 'Brand',
                                     labelStyle: TextStyle(color: Colors.grey),
                                     enabledBorder: UnderlineInputBorder(
                                       borderSide: BorderSide(
                                         color: Colors.grey[300],
                                       ),
                                     ),
                                   ),
                                 ),
                                 TextFormField(
                                   validator: (value){
                                     if(value.isEmpty){
                                       return 'Enter SKU';
                                     }
                                     setState(() {
                                       sku = value;
                                     });
                                   },
                                   decoration: InputDecoration(
                                     labelText: 'SKU', //item code
                                     labelStyle: TextStyle(color: Colors.grey),
                                     enabledBorder: UnderlineInputBorder(
                                       borderSide: BorderSide(
                                         color: Colors.grey[300],
                                       ),
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
                                       IconButton(
                                         icon: Icon(Icons.edit_outlined),
                                         onPressed: (){
                                           showDialog(
                                             context: context,
                                             builder: (BuildContext contect){
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
                                 TextFormField(
                                   validator: (value){
                                     if(value.isEmpty){
                                       return 'Select weight';
                                     }
                                     setState(() {
                                       weight = value;
                                     });
                                     return null;
                                   },
                                   decoration: InputDecoration(
                                     labelText: 'Weight (e.g. Kg, g, etc.)',
                                     labelStyle: TextStyle(color: Colors.grey),
                                     enabledBorder: UnderlineInputBorder(
                                       borderSide: BorderSide(
                                         color: Colors.grey[300],
                                       ),
                                     ),
                                   ),
                                 ),
                                 TextFormField(
                                   controller: _taxTextController,
                                   //not required
                                   keyboardType: TextInputType.number,
                                   decoration: InputDecoration(
                                     labelText: 'Tax %',
                                     labelStyle: TextStyle(color: Colors.grey),
                                     enabledBorder: UnderlineInputBorder(
                                       borderSide: BorderSide(
                                         color: Colors.grey[300],
                                       ),
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ],
                       ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              SwitchListTile(
                                title: Text('Track Inventory'),
                                activeColor: Theme.of(context).primaryColor,
                                subtitle: Text('Switch ON to track inventory',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12
                                  ),
                                ),
                                value: _track,
                                onChanged: (selected){
                                  setState(() {
                                    _track = !_track;
                                  });
                                },
                              ),
                              Visibility(
                                visible: _track,
                                child: SizedBox(
                                  height: 300,
                                  width: double.infinity,
                                  child: Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: _stockTextController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Inventory Quantity*',
                                              labelStyle: TextStyle(color: Colors.grey),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey[300],
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            controller: _lowStockTextController,
                                            //not required
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Inventory low stock quantity',
                                              labelStyle: TextStyle(color: Colors.grey),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey[300],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
