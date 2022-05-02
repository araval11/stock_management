import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management/bloc/statemanagement_bloc.dart';
import 'package:stock_management/models/items.dart';
import 'package:stock_management/screens/add_item.dart';
import 'package:stock_management/screens/profile-screen.dart';

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
        title: Text(
          'Hello ${widget.name} !!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<StatemanagementBloc, StatemanagementState>(
          builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('item').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.amber,
                  ),
                );
              }
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return ListTile(
                    title: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Item Name: ${data['itemname']}'),
                            Text('Description: ${data['description']}'),
                          ],
                        ),
                        Text('Quantity: ${data['quantity']}'),
                        Divider(
                          thickness: 2.0,
                        )
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        );
      }),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                iconSize: 30.0,
                onPressed: () {},
                icon: Icon(Icons.home),
                color: Colors.white,
              ),
              IconButton(
                iconSize: 30.0,
                onPressed: () {},
                icon: Icon(Icons.change_circle),
                color: Colors.white,
              ),
              IconButton(
                iconSize: 30.0,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return AddItem(name: widget.name, email: widget.email);
                  }));
                },
                icon: Icon(Icons.add),
                color: Colors.white,
              ),
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
      ),
    );
  }
}
