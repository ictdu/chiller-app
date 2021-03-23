import 'package:chiller_admin/widgets/category/subcategory_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final DocumentSnapshot document;
  CategoryCard(this.document);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: (){
        showDialog(
            context: context,
            builder: (BuildContext context){
              return SubCategoryWidget(document['name']);
            }
        );
      },
      child: SizedBox(
        height: 140,
        width: 120,
        child: Card(
          color: Colors.grey[100],
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Image.network(document['image']),
                  ),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(document['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
