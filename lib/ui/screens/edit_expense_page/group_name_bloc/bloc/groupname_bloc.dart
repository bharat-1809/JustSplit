import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contri_app/global/global_helpers.dart';
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
    if (event is GroupNameChanged) {
      if (event.groupId == null)
        yield (GroupnameState(groupName: "NO GROUP"));
      else {
        final groupName = getCurrentGroups
            .firstWhere((element) => element.id == event.groupId)
            .name;
        yield (GroupnameState(groupName: groupName));
      }
    }
  }
}
