import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

part 'splitdropdown_event.dart';
part 'splitdropdown_state.dart';

class SplitdropdownBloc extends Bloc<SplitdropdownEvent, SplitdropdownState> {
  SplitdropdownBloc() : super(SplitdropdownState(value: " ", splitList: []));

  @override
  Stream<SplitdropdownState> mapEventToState(
    SplitdropdownEvent event,
  ) async* {
    List<String> splittingTypes = [
      "Paid by you and split equally",
      "You owe the full amount",
      "They owe the full amount",
      "Paid by the other person and split Equally",
    ];

    if (event is SplitDropdownRequested) {
      if (event.isGroupExpense) {
        yield (SplitdropdownState(
          value: splittingTypes[0],
          splitList: [splittingTypes[0]],
        ));
      } else {
        if (event.initialValue != null) {
          splittingTypes.insert(0, "${'_' + event.initialValue}");
          yield (SplitdropdownState(
              value: splittingTypes[0], splitList: splittingTypes));
        } else {
          yield (SplitdropdownState(
              value: splittingTypes[0], splitList: splittingTypes));
        }
      }
    }
    if (event is ChangeSplitDropdown) {
      yield (SplitdropdownState(
          value: event.newValue, splitList: event.splitList));
    }
  }
}
