import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contri_app/sdk/functions/expenses_functions.dart';
import 'package:contri_app/sdk/functions/friends_functions.dart';
import 'package:contri_app/sdk/functions/group_functions.dart';
import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/global/storage_constants.dart';
import 'package:contri_app/ui/components/customTile.dart';
import 'package:contri_app/ui/components/scren_arguments.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

part 'detailexp_event.dart';
part 'detailexp_state.dart';

class DetailexpBloc extends Bloc<DetailexpEvent, DetailexpState> {
  DetailexpBloc()
      : super(
          DetailexpInitialState(
            pictureUrl: " ",
            name: " ",
            isGroupExpDetail: false,
            netBalance: 0.0,
            widgetList: [],
          ),
        );

  @override
  Stream<DetailexpState> mapEventToState(
    DetailexpEvent event,
  ) async* {
    try {
      if (event is DetailExpPageRequested) {
        if (event.isGroupExpDetail) {
          double _netBalance = 0.0;
          List<CustomTile> _widgetList = [];

          final _expenses = getCurrentExpenses
              .where((element) => element.groupId == event.argObject.group.id)
              .toList();
          _expenses.sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

          final _revList = _expenses.reversed.toList();

          for (var _exp in _revList) {
            final _expUsers = _exp.expenseUsers;
            final _expUsr = _expUsers.firstWhere(
              (element) => element.userId == globalUser.id,
              orElse: () => null,
            );
            final _creator = _expUsers.firstWhere(
              (element) => element.userId == _exp.to,
              orElse: () => null,
            );
            final _creatorName = _creator.user.firstName;
            if (_expUsr != null) {
              _netBalance += (_expUsr.netBalance);
              _widgetList.add(
                CustomTile(
                  heroTag: "${_exp.id}",
                  name: _exp.description,
                  balance: (_expUsr.netBalance),
                  photoUrl: _exp.pictureUrl ?? "${expenseAvatars[0]}",
                  argObject: ScreenArguments(expense: _exp),
                  subTitle: _creatorName == globalUser.firstName ? "By you" : "By $_creatorName",
                ),
              );
            }
          }

          yield (DetailexpInitialState(
            id: event.argObject.group.id,
            name: event.argObject.group.name,
            pictureUrl: event.argObject.group.pictureUrl ?? "${userAvatars[0]}",
            isGroupExpDetail: true,
            widgetList: _widgetList,
            netBalance: _netBalance,
          ));
        } else {
          double _netBalance = 0.0;
          List<CustomTile> _widgetList = [];
          // This adds all non-group expenses
          final _nonGroupexpenses =
              getCurrentExpenses.where((element) => element.groupId == null).toList();
          final _expenses = _nonGroupexpenses
              .where(
                (element) => element.to == event.argObject.friend.id,
              )
              .toList();
          _expenses.sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
          final _revList = _expenses.reversed.toList();
          for (var _exp in _revList) {
            _netBalance += _exp.owedShare;
            _widgetList.add(
              CustomTile(
                heroTag: "${_exp.id}",
                name: _exp.description,
                balance: _exp.owedShare,
                photoUrl: _exp.pictureUrl ?? "${expenseAvatars[0]}",
                argObject: ScreenArguments(expense: _exp),
              ),
            );
          }

          // This adds group expenses to the list
          final _groupExp = getCurrentExpenses.where((element) => element.groupId != null).toList();
          _groupExp.sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
          final _revGroupList = _groupExp.reversed.toList();

          for (var _exp in _revGroupList) {
            if (_exp.to == event.argObject.friend.id) {
              final _expUsers = _exp.expenseUsers;
              if (_expUsers != null) {
                final _expUsr = _expUsers.firstWhere(
                  (element) => element.userId == globalUser.id,
                  orElse: () => null,
                );

                if (_expUsr != null) {
                  _netBalance += (_expUsr.netBalance);
                  _widgetList.add(
                    CustomTile(
                        heroTag: "${_exp.id}",
                        name: _exp.description,
                        balance: (_expUsr.netBalance),
                        photoUrl: _exp.pictureUrl ?? "${expenseAvatars[0]}",
                        argObject: ScreenArguments(expense: _exp),
                        subTitle: "By ${event.argObject.friend.friend.firstName}"),
                  );
                }
              }
            } else if (_exp.to == globalUser.id) {
              final _expenseUsers = _exp.expenseUsers;
              final _expUser = _expenseUsers.firstWhere(
                (element) => element.userId == event.argObject.friend.id,
                orElse: () => null,
              );

              if (_expUser != null) {
                _netBalance += -(_expUser.netBalance);
                _widgetList.add(
                  CustomTile(
                    heroTag: "${_exp.id}",
                    name: _exp.description,
                    balance: -(_expUser.netBalance),
                    photoUrl: _exp.pictureUrl ?? "${expenseAvatars[0]}",
                    argObject: ScreenArguments(expense: _exp),
                    subTitle: "By you",
                  ),
                );
              }
            }
          }
          yield (DetailexpInitialState(
            id: event.argObject.friend.id,
            pictureUrl: event.argObject.friend.friend.pictureUrl ?? "${userAvatars[0]}",
            name:
                "${event.argObject.friend.friend.firstName + ' ' + event.argObject.friend.friend.lastName}",
            phoneNumber: event.argObject.friend.friend.phoneNumber,
            isGroupExpDetail: false,
            widgetList: _widgetList,
            netBalance: _netBalance,
          ));
        }
      } else if (event is SettleUpExpenses) {
        yield (DetailExpLoading());

        final _expenses = getCurrentExpenses.where((element) => element.to == event.userId);
        for (var _exp in _expenses) {
          final _expCopy = _exp;
          _expCopy.cost = 0.0;
          _expCopy.owedShare = 0.0;
          _expCopy.updatedBy = globalUser.id;

          ExpensesFunctions.updateExpense(id: _exp.id, expense: _expCopy);
          getCurrentExpenses.removeWhere((e) => e.id == _exp.id);
          getCurrentExpenses.add(_expCopy);
        }
        await loadExpenses();

        yield (DetailExpSuccess());
      } else if (event is DeleteGroup) {
        yield (DetailExpLoading());

        GroupFunctions.deleteGroup(id: event.groupId);

        getCurrentGroups.removeWhere((g) => g.id == event.groupId);
        getCurrentExpenses.removeWhere((e) => e.groupId == event.groupId);

        yield (DeleteGroupSuccess());
      }
      if (event is DeleteFriend) {
        yield DetailExpLoading();
        await FriendFunctions.deleteFriend(id: event.friendId);
        yield DeleteFriendSuccess();
      }
    } on PlatformException catch (e) {
      yield (DetailExpFailure(message: "Error: ${e.message}"));
    } on TimeoutException catch (e) {
      yield (DetailExpFailure(message: "Timeout: ${e.message}"));
    } catch (e) {
      yield (DetailExpFailure(message: e.toString()));
    }
  }
}
