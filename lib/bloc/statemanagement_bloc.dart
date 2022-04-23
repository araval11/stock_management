import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'statemanagement_event.dart';
part 'statemanagement_state.dart';

class StatemanagementBloc extends Bloc<StatemanagementEvent, StatemanagementState> {
  StatemanagementBloc() : super(StatemanagementInitial()) {
    on<StatemanagementEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
