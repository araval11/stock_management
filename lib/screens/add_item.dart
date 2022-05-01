import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management/bloc/statemanagement_bloc.dart';
import '../components/round_button.dart';
import '../utilities/constants.dart';
import 'home_screen.dart';

class AddItem extends StatefulWidget {
  final String email;
  final String name;
  AddItem({required this.email, required this.name});
  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String itemName = 'default';

  String description = 'default';

  String quantity = 'default';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                colour: Colors.blue,
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
