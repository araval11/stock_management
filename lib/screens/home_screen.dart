import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_management/bloc/statemanagement_bloc.dart';
import 'package:stock_management/screens/add_item.dart';
import 'package:stock_management/screens/profile-screen.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  final String name;

  const HomeScreen({Key? key, required this.email, required this.name})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    currentuser();
  }

  void currentuser() async {
    final user = auth.currentUser;
    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', user.email.toString());
      prefs.setString('name', user.displayName.toString());
      prefs.setBool('isloggedin', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Hello ${widget.name} !!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<StatemanagementBloc, StatemanagementState>(
          builder: (context, state) {
        if (state is LoadDatastate) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.separated(
                itemBuilder: (_, i) {
                  final items = state.items[i];
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('${items.name}'),
                        Text('${items.description}'),
                        Text('${items.quantity}'),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, i) {
                  return Divider();
                },
                itemCount: state.items.length),
          );
        } else {
          return ListView.separated(
              itemBuilder: (_, i) {
                return ListTile(
                  title: Row(children: [Text('No Data')]),
                );
              },
              separatorBuilder: (_, i) {
                return Divider();
              },
              itemCount: 1);
        }
      }),
      bottomNavigationBar: BottomAppBar(
        color: Colors.red,
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
