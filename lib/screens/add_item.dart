import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stock_management/screens/select_item_screen.dart';
import '../components/round_button.dart';
import '../utilities/constants.dart';

class AddItem extends StatefulWidget {
  final String itemname;
  final String description;
  final String docid;
  AddItem(
      {required this.itemname, required this.description, required this.docid});
  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String itemName = 'default';
  String description = 'default';
  String quantity = 'default';
  String lowstock = 'default';
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
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('item').snapshots(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blueGrey,
              title: Text('Add Item'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      height: 150,
                      width: 150,
                      child: image != null
                          ? Image.file(
                              image!,
                              fit: BoxFit.cover,
                            )
                          : IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        padding: EdgeInsets.all(10.0),
                                        height: 150.0,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                  pickImage(
                                                      ImageSource.gallery);
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
                              icon: Icon(Icons.add_a_photo),
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
                    Container(
                      width: 200.0,
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(primary: Colors.blueGrey),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return SelectItemScreen();
                          }));
                        },
                        child: Text(
                          '${widget.itemname}',
                          style: TextStyle(fontSize: 30.0),
                        ),
                      ),
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
                      decoration: ktextfielddecoration.copyWith(
                          hintText: 'Enter the quantity'),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        lowstock = value;
                      },
                      decoration: ktextfielddecoration.copyWith(
                          hintText: 'Low Stock Qunatity'),
                    ),
                    RoundButton(
                        colour: Colors.blueGrey,
                        onTap: () async {
                          final data = snapshot.data!.docs;
                          var itemdata = 'default';
                          int update = 0;
                          for (var i in data) {
                            itemdata = i['itemname'];
                            var quantitydata = i['quantity'];
                            if (widget.itemname == itemdata) {
                              update = 1;
                              await FirebaseFirestore.instance
                                  .collection('item')
                                  .doc(widget.docid)
                                  .update({
                                'quantity': (int.parse(quantitydata) +
                                        int.parse(quantity))
                                    .toString()
                              });
                              await FirebaseFirestore.instance
                                  .collection('transactions')
                                  .add({
                                'timestamp': DateTime.now(),
                                'quantity': quantity,
                                'out': 'IN',
                                'itemname': i['itemname']
                              });
                            }
                          }
                          if (widget.itemname != itemdata && update == 0) {
                            await FirebaseFirestore.instance
                                .collection('item')
                                .add({
                              'description': description,
                              'itemname': itemName,
                              'quantity': quantity,
                              'lowstock': lowstock
                            });
                          }

                          Navigator.pop(context);
                        },
                        title: 'Done')
                  ],
                ),
              ),
            ),
          );
        });
  }
}
