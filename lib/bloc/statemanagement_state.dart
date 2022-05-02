part of 'statemanagement_bloc.dart';

abstract class StatemanagementState extends Equatable {
  const StatemanagementState();

  @override
  List<Object> get props => [];
}

class Initialstate extends StatemanagementState {}

class LoadDatastate extends StatemanagementState {}

class Transactionstate extends StatemanagementState {}
