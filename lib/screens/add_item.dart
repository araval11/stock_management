import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stock_management/bloc/statemanagement_bloc.dart';
import '../components/round_button.dart';
import '../utilities/constants.dart';
import 'home_screen.dart';

class AddItem extends StatefulWidget {
  final String? email;
  final String? name;
  AddItem({required this.email, required this.name});
  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String itemName = 'default';
  String description = 'default';
  String quantity = 'default';
  File? image;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imagetemporary = File(image.path);
      setState(() {
        this.image = imagetemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              height: 150,
              width: 150,
              child: IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          padding: EdgeInsets.all(10.0),
                          height: 150.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    pickImage(ImageSource.camera);
                                    Navigator.pop(context);
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.camera),
                                    SizedBox(width: 20),
                                    Text('Camera')
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Divider(),
                              SizedBox(height: 10),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    pickImage(ImageSource.gallery);
                                    Navigator.pop(context);
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.photo_album),
                                    SizedBox(width: 20),
                                    Text('Gallery')
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      });
                },
                icon: image != null
                    ? Image.file(
                        image!,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.add_a_photo),
                iconSize: 80.0,
                color: Colors.white,
              ),
            ),
            IconButton(
              splashRadius: 25.0,
              onPressed: () {
                setState(() {
                  image = null;
                });
              },
              icon: Icon(Icons.cancel),
              iconSize: 40.0,
              color: Colors.red,
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  itemName = value;
                },
                decoration: ktextfielddecoration.copyWith(
                    hintText: 'Enter the name of item')),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                description = value;
              },
              decoration: ktextfielddecoration.copyWith(
                  hintText: 'Enter the decription of item'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              onChanged: (value) {
                quantity = value;
              },
              decoration:
                  ktextfielddecoration.copyWith(hintText: 'Enter the quantity'),
            ),
            RoundButton(
                colour: Colors.blueGrey,
                onTap: () {
                  context.read<StatemanagementBloc>().add(
                        adddata(
                            description: description,
                            itemname: itemName,
                            quantity: quantity),
                      );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen(email: widget.email, name: widget.name),
                    ),
                  );
                },
                title: 'Done')
          ],
        ),
      ),
    );
  }
}
