import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransactionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Transaction Screen'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('transactions')
                .snapshots(),
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
                        .collection('transactions')
                        .doc(doc_id)
                        .delete();
                  },
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          '${data['quantity']}',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          '${data['out']}',
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Item_Name : ${data['itemname']}'),
                        SizedBox(height: 10.0),
                        Text('${data['timestamp'].toDate()}'),
                        SizedBox(height: 10.0),
                        Divider(
                          thickness: 2,
                        )
                      ],
                    ),
                  ),
                );
              }).toList());
            }));
  }
}
