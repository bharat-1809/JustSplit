import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/global/storage_constants.dart';
import 'package:contri_app/ui/components/scren_arguments.dart';
import 'package:contri_app/ui/components/userTile_addExpPage.dart';
import 'package:contri_app/ui/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'namedropdown_event.dart';
part 'namedropdown_state.dart';

class NamedropdownBloc extends Bloc<NamedropdownEvent, NamedropdownState> {
  NamedropdownBloc() : super(NameDropdownChanged(value: " ", dropdownList: []));

  @override
  Stream<NamedropdownState> mapEventToState(
    NamedropdownEvent event,
  ) async* {
    try {
      if (event is NameDropdownRequested) {
        if (event.initialNameDropdownValue != null) {
          if (event.initialNameDropdownValue.friend != null) {
            final _friend = event.initialNameDropdownValue.friend;
            final UserTile _userTile = UserTile(
              name:
                  "${_friend.friend.firstName + ' ' + _friend.friend.lastName}",
              id: _friend.id,
              photoUrl: _friend.friend.pictureUrl,
            );
            yield (NameDropdownChanged(
                value: _friend.id, dropdownList: [_userTile]));
          } else {
            final _group = event.initialNameDropdownValue.group;
            final UserTile _groupTile = UserTile(
              name: _group.name,
              id: _group.id,
              photoUrl: _group.pictureUrl ?? userAvatars[4],
            );
            yield (NameDropdownChanged(
                value: _group.id, dropdownList: [_groupTile]));
          }
        } else {
          List<UserTile> _usersList = [];
          for (var _user in getCurrentFriends) {
            _usersList.add(
              UserTile(
                name: "${_user.friend.firstName + ' ' + _user.friend.lastName}",
                id: _user.id,
                photoUrl: _user.friend.pictureUrl,
              ),
            );
          }

          for (var _group in getCurrentGroups) {
            _usersList.add(
              UserTile(
                name: _group.name,
                id: _group.id,
                photoUrl: _group.pictureUrl ?? userAvatars[4],
              ),
            );
          }

          _usersList.add(
            UserTile(
              name: "Add Friend",
              id: kAddFriendId,
              photoUrl: userAvatars[Random().nextInt(userAvatars.length)],
            ),
          );

          yield (NameDropdownChanged(
              value: _usersList[0].id, dropdownList: _usersList));
        }
      }
      if (event is ChangeNameDropdown) {
        if (event.newValue == kAddFriendId) {
          yield (AddingNewFriend());
        }

        yield (NameDropdownChanged(
            value: event.newValue, dropdownList: event.dropdownList));
      }
    } catch (e) {
      yield (NameDropdownChangeFailure(message: e.toString()));
    }
  }
}
