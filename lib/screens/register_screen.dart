import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stock_management/screens/login_screen.dart';

import '../components/round_button.dart';
import '../utilities/constants.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Text(
                    'Register Yourself',
                    style:
                        TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: ktextfielddecoration.copyWith(
                      hintText: 'Enter Your Email'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: ktextfielddecoration.copyWith(
                      hintText: 'Enter Your Password'),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundButton(
                  colour: Colors.lightBlueAccent,
                  title: 'Register',
                  onTap: () async {
                    try {
                      final newuser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newuser != null) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) {
                            return LoginScreen();
                          }),
                          ModalRoute.withName('/'),
                        );
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
