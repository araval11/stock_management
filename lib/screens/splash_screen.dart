import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stock_management/screens/home_screen.dart';
import 'package:stock_management/screens/login_screen.dart';

import '../utilities/fingerprint_api.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    navigatescreen();
  }

  navigatescreen() async {
    final user = auth.currentUser;
    String? email = 'default';
    String? name = 'default';

    await Future.delayed(Duration(milliseconds: 1500));
    if (user != null) {
      final isAuthenticated = await LocalAuthApi.authenticate();
      if (isAuthenticated) {
        await _firestore
            .collection('profile')
            .get()
            .then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((f) {
            String namedata = f['fullname'];
            String emaildata = f['email'];

            if (user.email == emaildata) {
              name = namedata;
              email = emaildata;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(email: email, name: name),
                ),
              );
            }
          });
        });
        if (email == 'default') {
          email = user.email;
          name = user.displayName;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(email: email, name: name),
            ),
          );
        }
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Splash Screen',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
