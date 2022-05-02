import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management/models/items.dart';
part 'statemanagement_event.dart';
part 'statemanagement_state.dart';

class StatemanagementBloc
    extends Bloc<StatemanagementEvent, StatemanagementState> {
  String itemname = 'default';
  String quantity = 'default';
  String description = 'default';
  int length = 0;
  List<Item> itemsdata = [];
  final _firestore = FirebaseFirestore.instance;
  StatemanagementBloc() : super(Initialstate()) {
    on<adddata>(_addData);
    on<register>(_register);
  }

  void _addData(adddata, emit) async {
    await _firestore.collection('item').add({
      'description': adddata.description,
      'itemname': adddata.itemname,
      'quantity': adddata.quantity
    });
  }

  void _register(register, emit) {}
}
