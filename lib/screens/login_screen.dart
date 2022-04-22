import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stock_management/screens/home_screen.dart';
import 'package:stock_management/utilities/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignInAccount? user;
  GoogleSignInAuthentication? googleauth;
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;

  void authentication() async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return HomeScreen(email: email, name: password);
        }));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return LoginScreen();
        }));
      }
    } catch (e) {
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
      body: Center(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
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
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30.0),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              authentication();
                            });
                          },
                          minWidth: 200.0,
                          height: 42.0,
                          child: Text(
                            'Login In',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(30.0),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () async {
                            user = await GoogleSignIn().signIn();
                            googleauth = await user!.authentication;
                            final OAuthCredential googlecredential =
                                GoogleAuthProvider.credential(
                              accessToken: googleauth!.accessToken,
                              idToken: googleauth!.idToken,
                            );
                            final User? googleuserCredential = (await _auth
                                    .signInWithCredential(googlecredential))
                                .user;
                            email = user!.email.toString();

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
                          minWidth: 200.0,
                          height: 42.0,
                          child: Text(
                            'google sign in ',
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
