import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LowStockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Low Stock Screen'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('lowstock').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.amber,
                  ),
                );
              }
              return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                var doc_id = document.id;

                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return InkWell(
                  onLongPress: () async {
                    await FirebaseFirestore.instance
                        .collection('lowstock')
                        .doc(doc_id)
                        .delete();
                  },
                  child: ListTile(
                    title: Text('Item_Name : ${data['itemname']}'),
                    subtitle: Text('Item_Name : ${data['quantity']}'),
                  ),
                );
              }).toList());
            }));
  }
}
