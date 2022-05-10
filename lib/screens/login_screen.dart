import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stock_management/components/round_button.dart';
import 'package:stock_management/screens/home_screen.dart';
import 'package:stock_management/screens/register_screen.dart';
import 'package:stock_management/utilities/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignInAccount? user;
  GoogleSignInAuthentication? googleauth;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late String email;
  late String password;
  String name = 'no name';
  bool showSpinner = false;

  void authentication() async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _firestore
          .collection('profile')
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((f) {
          String namedata = f['fullname'];
          String emaildata = f['email'];
          if (email == emaildata) {
            name = namedata;
          }
        });
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) {
          return HomeScreen(
            email: email,
            name: name,
          );
        }),
        ModalRoute.withName('/'),
      );
    } catch (e) {
      showSpinner = false;
      final snackBar = SnackBar(
        content: const Text('You had entered wrong credentials!!'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            setState(() {});
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Login In',
                      style: TextStyle(
                          fontSize: 50.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: ktextfielddecoration.copyWith(
                          hintText: 'Enter your Email Adress')),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: ktextfielddecoration.copyWith(
                        hintText: 'Enter your Password'),
                  ),
                  RoundButton(
                      colour: Colors.blueGrey,
                      onTap: () {
                        setState(() {
                          showSpinner = true;
                        });
                        authentication();
                      },
                      title: 'LoginIn'),
                  SizedBox(
                    height: 30.0,
                  ),
                  RoundButton(
                    colour: Colors.grey,
                    onTap: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      user = await GoogleSignIn().signIn();
                      googleauth = await user!.authentication;
                      final OAuthCredential googlecredential =
                          GoogleAuthProvider.credential(
                        accessToken: googleauth!.accessToken,
                        idToken: googleauth!.idToken,
                      );
                      final User? googleuserCredential =
                          (await _auth.signInWithCredential(googlecredential))
                              .user;
                      email = user!.email.toString();
                      setState(() {
                        showSpinner = true;
                      });
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) {
                          return HomeScreen(
                            email: user!.email,
                            name: user!.displayName ?? 'no name',
                          );
                        }),
                        ModalRoute.withName('/'),
                      );
                    },
                    title: 'Google SignIn',
                  ),
                  RoundButton(
                      colour: Colors.blueGrey,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => RegistrationScreen()));
                      },
                      title: 'Register'),
                ],
              ),
            ),
          ),
        ),
        if (showSpinner)
          Center(
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          )
      ]),
    );
  }
}
