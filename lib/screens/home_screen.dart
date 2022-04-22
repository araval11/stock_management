import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_management/screens/login_screen.dart';

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
        title: Text('Home Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(widget.email),
          ),
          SizedBox(height: 10.0),
          Center(
            child: Text(widget.name),
          ),
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
    );
  }
}
