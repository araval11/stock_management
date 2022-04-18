import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String email;
  final String name;
  const HomeScreen({Key? key, required this.email, required this.name})
      : super(key: key);

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
            child: Text(email),
          ),
          SizedBox(height: 10.0),
          Center(
            child: Text(name),
          ),
        ],
      ),
    );
  }
}
