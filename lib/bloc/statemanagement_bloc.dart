import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management/models/items.dart';
part 'statemanagement_event.dart';
part 'statemanagement_state.dart';

class StatemanagementBloc
    extends Bloc<StatemanagementEvent, StatemanagementState> {
  List<Item> items = [];
  StatemanagementBloc() : super(Initialstate()) {
    on<adddata>(_addData);
    on<register>(_register);
  }

  void _addData(adddata, emit) async {
    items.add(
      Item(
          name: adddata.itemname,
          description: adddata.description,
          quantity: adddata.quantity),
    );

    emit(LoadDatastate(items: items));
  }

  void _register(register, emit) {}
}
