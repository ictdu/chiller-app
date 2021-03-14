import 'package:chiller_admin/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VendorDataTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return StreamBuilder(
        stream: _services.vendors.orderBy('shopName', descending: true).snapshots(),
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
        });
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
            icon: Icon(Icons.remove_red_eye_outlined),
            onPressed: (){},
          )),
        ]
      );
    }).toList();
    return newList;
  }
}
