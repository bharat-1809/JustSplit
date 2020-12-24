import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'date_event.dart';
part 'date_state.dart';

class DateBloc extends Bloc<DateEvent, DateState> {
  DateBloc() : super(DateState(dateTime: DateTime.now()));

  @override
  Stream<DateState> mapEventToState(
    DateEvent event,
  ) async* {
    if (event is DateChanged) {
      yield (DateState(dateTime: event.newDateTime));
    }
  }
}
