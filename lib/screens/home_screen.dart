import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stock_management/components/round_button.dart';
import 'package:stock_management/models/items.dart';
import 'package:stock_management/screens/add_item.dart';
import 'package:stock_management/screens/low_stock_screen.dart';
import 'package:stock_management/screens/profile-screen.dart';
import 'package:stock_management/screens/transaction_screen.dart';
import 'package:stock_management/utilities/constants.dart';

class HomeScreen extends StatefulWidget {
  final String? email;
  final String? name;

  const HomeScreen({Key? key, required this.email, required this.name})
      : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  List<Item> itemsdata = [];
  String itemname = 'default';
  String quantity = 'default';
  String description = 'default';
  int length = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Row(
          children: [
            Text(
              'Hello ${widget.name} !!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Spacer(),
            IconButton(
              iconSize: 30.0,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return ProfileScreen();
                }));
              },
              icon: Icon(Icons.person),
              color: Colors.white,
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blueGrey, elevation: 6.0),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return TransactionScreen();
                        }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 10.0, right: 10.0, bottom: 16.0),
                        child: Text(
                          'Transactions >',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      )),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return LowStockScreen();
                        }));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(2.0, 2.0),
                                spreadRadius: 0.0, //(x,y)
                                blurRadius: 10.0,
                              ),
                            ],
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Low Stock',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              '0 items',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Divider(thickness: 3),
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('item').snapshots(),
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

                      if (int.parse(data['quantity']) <=
                          int.parse(data['lowstock'])) {
                        FirebaseFirestore.instance.collection('lowstock').add({
                          'itemname': data['itemname'],
                          'quantity': data['quantity']
                        });
                      }
                      return InkWell(
                        onLongPress: () async {
                          await FirebaseFirestore.instance
                              .collection('item')
                              .doc(doc_id)
                              .delete();
                        },
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (_) {
                                return Container(
                                  height: 400.0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, left: 16.0, right: 16.0),
                                    child: Column(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Item Name: ${data['itemname']}',
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Spacer(),
                                                Text(
                                                  '${data['quantity']}',
                                                  style: TextStyle(
                                                      fontSize: 30.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                              'Description: ${data['description']}',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Container(
                                          width: 200.0,
                                          child: TextField(
                                            textAlign: TextAlign.center,
                                            decoration:
                                                ktextfielddecoration.copyWith(
                                                    hintText: 'Sell Product'),
                                            onChanged: (value) {
                                              quantity = value;
                                            },
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        RoundButton(
                                            colour: Colors.blueGrey,
                                            onTap: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('item')
                                                  .doc(doc_id)
                                                  .update({
                                                'quantity': (int.parse(
                                                            data['quantity']) -
                                                        int.parse(quantity))
                                                    .toString()
                                              });
                                              FirebaseFirestore.instance
                                                  .collection('transactions')
                                                  .add({
                                                'timestamp': DateTime.now(),
                                                'quantity': quantity,
                                                'out': 'OUT',
                                                'itemname': data['itemname']
                                              });

                                              Navigator.pop(context);
                                            },
                                            title: 'Sell')
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: ListTile(
                          title: Row(
                            children: [
                              Text('Item Name: ${data['itemname']}'),
                              Spacer(),
                              Text(
                                '${data['quantity']}',
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Description: ${data['description']}'),
                              SizedBox(
                                height: 10.0,
                              ),
                              Divider(
                                thickness: 2.0,
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 30.0,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return AddItem(
                      itemname: 'Select Item',
                      description: 'Description',
                      docid: '',
                    );
                  }));
                },
                icon: Icon(Icons.add),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
