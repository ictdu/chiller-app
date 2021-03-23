import 'package:chiller_admin/services/firebase_services.dart';
import 'package:chiller_admin/widgets/vendor/vendor_details_box.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VendorDataTable extends StatefulWidget {
  @override
  _VendorDataTableState createState() => _VendorDataTableState();
}

class _VendorDataTableState extends State<VendorDataTable> {
  FirebaseServices _services = FirebaseServices();

  int tag = 0;
  List<String> options = [
    'All Vendors', //0
    'Verified Vendors', //1
    'Unverified Vendors', //2
    'Top Picked', //3
    'Top Rated', //4
    //can add more
  ];

  bool topPicked;
  bool accVerified;

  filter(val){
    if(val == 0){
      setState(() {
        topPicked = null;
        accVerified = null;
      });
    }
    if(val == 1){
      setState(() {
        accVerified = true;
      });
    }
    if(val == 2){
      setState(() {
        accVerified = false;
      });
    }
    if(val == 3){
      setState(() {
        topPicked = true;
      });
    }
    // val 4 will be added on the future
    if(val == 4){
      setState(() {
        topPicked = null;
        accVerified = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChipsChoice<int>.single(
          value: tag,
            onChanged: (val){
            setState(() {
              tag = val;
            });
            filter(val);
            },
            choiceItems: C2Choice.listFrom<int, String>(
              activeStyle: (i, v){
                return C2ChoiceStyle(
                  brightness: Brightness.dark,
                  color: Colors.black54,

                );
              },
              source: options,
              value: (i, v) => i,
              label: (i, v) => v,
          ),
        ),
        Divider(thickness: 5),
        StreamBuilder(
            stream: _services.vendors.where('accVerified', isEqualTo: accVerified).where('isTopPicked', isEqualTo: topPicked).snapshots(),
            builder: (context, snapshot){
              if(snapshot.hasError){
                return Text('Something went wrong.');
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  showBottomBorder: true,
                  dataRowHeight: 60,
                  headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                  //table headers
                  columns: <DataColumn> [
                    DataColumn(label: Text('Verified')),
                    DataColumn(label: Text('Top Picked')),
                    DataColumn(label: Text('Shop Name')),
                    DataColumn(label: Text('Rating')),
                    DataColumn(label: Text('Total Sales')),
                    DataColumn(label: Text('Mobile')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('View Details')),
                  ],
                  //details
                  rows: _vendorDetailsRows(
                      snapshot.data,
                      _services,
                  ),
                ),
              );
            }),
          ],
    );
  }

  List<DataRow> _vendorDetailsRows(QuerySnapshot snapshot, FirebaseServices services){
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document){
      return DataRow(
        cells: [
          DataCell(
            IconButton(
              onPressed: (){
                services.updateVendorStatus(
                  id: document.data()['uid'],
                  status: document.data()['accVerified'],
                );
              },
              icon: document.data()['accVerified']
                  ? Icon(Icons.check_circle, color: Colors.green,)
                  : Icon(Icons.radio_button_unchecked, color: Colors.grey,),
            ),
          ),
          DataCell(
            IconButton(
              onPressed: (){
                services.topPickedStatus(
                  id: document.data()['uid'],
                  status: document.data()['isTopPicked'],
                );
              },
              icon: document.data()['isTopPicked']
                  ? Icon(Icons.check_circle, color: Colors.green,)
                  : Icon(Icons.radio_button_unchecked, color: Colors.grey,),
            ),
          ),
          DataCell(Text(document.data()['shopName'])),
          DataCell(
            Row(
              children: [
                Icon(Icons.star_half, color: Colors.grey,),
                Text(' 3.5'),
              ],
            ),
          ), //temporary
          DataCell(Text('12,345')), //temporary
          DataCell(Text(document.data()['mobile'])),
          DataCell(Text(document.data()['email'])),
          DataCell(IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: (){
              //will popup vendor details screen
              showDialog(
                context: context,
                builder: (BuildContext context){
                  return VendorDetailsBox(document.data()['uid']);
                }
              );
            },
          )),
        ]
      );
    }).toList();
    return newList;
  }
}
