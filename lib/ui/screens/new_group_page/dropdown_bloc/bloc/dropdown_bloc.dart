import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/ui/components/userTile_addExpPage.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'dropdown_event.dart';
part 'dropdown_state.dart';

class DropdownBloc extends Bloc<DropdownEvent, DropdownState> {
  DropdownBloc() : super(DropdownState(value: "", widgetList: []));

  @override
  Stream<DropdownState> mapEventToState(
    DropdownEvent event,
  ) async* {
    if (event is FriendDropdownRequested) {
      final _friends = getCurrentFriends;
      List<UserTile> _widgetList = [];
      _friends.sort(
        (a, b) => a.friend.firstName
            .substring(0, 0)
            .compareTo(b.friend.firstName.substring(0, 0)),
      );
      for (var _friend in _friends) {
        _widgetList.add(
          UserTile(
            name: "${_friend.friend.firstName + ' ' + _friend.friend.lastName}",
            id: _friend.id,
            photoUrl: _friend.friend.pictureUrl ?? "NO IMAGE",
            arguments: _friend,
          ),
        );
      }
      yield (DropdownState(
        value: _widgetList[0].id,
        widgetList: _widgetList,
      ));
    } else if (event is ChangeFriendDropdown) {
      yield (DropdownState(
          value: event.newValue, widgetList: event.widgetList));
    }
  }
}
