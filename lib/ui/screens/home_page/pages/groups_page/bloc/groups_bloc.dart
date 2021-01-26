import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contri_app/sdk/models/expense_model/expense_model.dart';
import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/global/storage_constants.dart';
import 'package:contri_app/ui/components/customTile.dart';
import 'package:contri_app/ui/components/scren_arguments.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

part 'groups_event.dart';
part 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  GroupsBloc() : super(GroupsInitial());

  @override
  Stream<GroupsState> mapEventToState(
    GroupsEvent event,
  ) async* {
    if (event is GroupsRequested) {
      try {
        List<CustomTile> _groupsList = [];
        double _netBalance = 0.0;
        for (var _group in getCurrentGroups) {
          _netBalance = 0.0;
          final _expenses = getCurrentExpenses
              .where((element) => element.groupId == _group.id);
          if (_expenses.length > 0) {
            for (var _expense in _expenses) {
              final _expenseUser = _expense.expenseUsers.firstWhere(
                (element) => element.userId == globalUser.id,
                orElse: () => ExpenseUsers(),
              );
              _netBalance += _expenseUser.netBalance;
            }
          }
          String _members = "";
          for (var _user in _group.members) {
            _members += "${_user.firstName}, ";
          }
          _groupsList.add(
            CustomTile(
              heroTag: "${_group.id.toString()}",
              name: _group.name,
              balance: _netBalance,
              photoUrl: _group.pictureUrl ?? "${userAvatars[0]}",
              argObject: ScreenArguments(group: _group),
              subTitle: _members,
            ),
          );
        }
        yield (GroupsLoaded(groupsList: _groupsList));
      } on PlatformException catch (e) {
        yield (GroupsFailure(message: "Error: ${e.message}"));
      } on TimeoutException catch (e) {
        yield (GroupsFailure(message: "Timeout: ${e.message}"));
      } catch (e) {
        yield (GroupsFailure(message: e.toString()));
      }
    }
  }
}
