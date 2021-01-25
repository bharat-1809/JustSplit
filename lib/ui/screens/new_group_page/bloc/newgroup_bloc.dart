import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contri_app/sdk/functions/group_functions.dart';
import 'package:contri_app/sdk/models/group_model/group_model.dart';
import 'package:contri_app/sdk/models/user_model/user_model.dart';
import 'package:contri_app/global/global_helpers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

part 'newgroup_event.dart';
part 'newgroup_state.dart';

class NewgroupBloc extends Bloc<NewgroupEvent, NewgroupState> {
  NewgroupBloc() : super(NewgroupInitial());

  @override
  Stream<NewgroupState> mapEventToState(
    NewgroupEvent event,
  ) async* {
    try {
      if (event is CreateGroupButtonClicked) {
        yield (NewGroupLoading());
        Group _group;
        List<User> _members = [globalUser];
        for (var _friendId in event.members) {
          final _user = getCurrentFriends
              .firstWhere((element) => element.id == _friendId);
          _members.add(_user.friend);
        }
        _group = Group(
          pictureUrl: event.pictureUrl,
          members: _members,
          name: event.groupName,
          updatedAt: DateTime.now().toIso8601String(),
        );

        await GroupFunctions.createGroup(group: _group);
        await loadGroups();
        yield (NewGroupSuccess());
      } else if (event is ErrorSelectingFriend) {
        yield (NewGroupFailure(message: "Please Select more than two friends"));
        yield (NewgroupInitial());
      }
    } on PlatformException catch (e) {
      yield (NewGroupFailure(message: "Error: ${e.message}"));
    } on TimeoutException catch (e) {
      yield (NewGroupFailure(message: "Timeout: ${e.message}"));
    } catch (e) {
      yield (NewGroupFailure(message: e.toString()));
    }
  }
}
