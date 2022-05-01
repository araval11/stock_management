import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_management/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? email = 'default';
  String? name = 'default';
  String contact = 'default';
  final auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('profile').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final datas = snapshot.data!.docs;
          final user = auth.currentUser;
          for (var data in datas) {
            String namedata = data['fullname'];
            String emaildata = data['email'];
            String contactdata = data['contact'];
            if (user!.email == emaildata) {
              name = namedata;
              email = emaildata;
              contact = contactdata;
            }
          }
          if (email == 'default') {
            name = user!.displayName;
            email = user.email;
            contact = 'you need to register your contact';
          }
          return Scaffold(
            appBar: AppBar(title: Text('ProfileScreen')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Name: $name',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Text('Email: $email',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                  Text('Contact: $contact',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                  Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          await GoogleSignIn().signOut();
                          await auth.signOut();
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          await preferences.clear();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) {
                              return LoginScreen();
                            }),
                            ModalRoute.withName('/'),
                          );
                        },
                        child: Text('Logout')),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
