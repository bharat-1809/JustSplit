import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'groupname_event.dart';
part 'groupname_state.dart';

class GroupnameBloc extends Bloc<GroupnameEvent, GroupnameState> {
  GroupnameBloc() : super(GroupnameState(groupName: "NO GROUP"));

  @override
  Stream<GroupnameState> mapEventToState(
    GroupnameEvent event,
  ) async* {
    if (event is UpdateGroupName) {
      yield (GroupnameState(groupName: event.newName));
    }
  }
}
