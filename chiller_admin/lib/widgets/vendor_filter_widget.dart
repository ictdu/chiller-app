import 'package:flutter/material.dart';

class VendorFilterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ActionChip(
                  elevation: 3,
                  backgroundColor: Colors.black54,
                  label: Text('All Vendors', style:
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),),
                  onPressed: (){}),
              SizedBox(width: 8),
              ActionChip(
                  elevation: 3,
                  backgroundColor: Colors.black54,
                  label: Text('Active', style:
                  TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),),
                  onPressed: (){}),
              SizedBox(width: 8),
              ActionChip(
                  elevation: 3,
                  backgroundColor: Colors.black54,
                  label: Text('Inactive', style:
                  TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),),
                  onPressed: (){}),
              SizedBox(width: 8),
              ActionChip(
                  elevation: 3,
                  backgroundColor: Colors.black54,
                  label: Text('Top Picked', style:
                  TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),),
                  onPressed: (){}),
              SizedBox(width: 8),
              ActionChip(
                  elevation: 3,
                  backgroundColor: Colors.black54,
                  label: Text('Top Rated', style:
                  TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),),
                  onPressed: (){}),
            ],
          ),
        ),
      ),
    );
  }
}
