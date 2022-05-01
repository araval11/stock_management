part of 'statemanagement_bloc.dart';

abstract class StatemanagementEvent extends Equatable {
  const StatemanagementEvent();

  @override
  List<Object> get props => [];
}

class adddata extends StatemanagementEvent {
  final String itemname;
  final String description;
  final String quantity;

  adddata(
      {required this.description,
      required this.itemname,
      required this.quantity});
}

class register extends StatemanagementEvent {}
