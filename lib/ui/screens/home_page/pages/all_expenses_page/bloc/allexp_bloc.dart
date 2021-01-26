import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contri_app/sdk/models/friend_model/friend_model.dart';
import 'package:contri_app/sdk/models/user_model/user_model.dart';
import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/global/storage_constants.dart';
import 'package:contri_app/ui/components/customTile.dart';
import 'package:contri_app/ui/components/scren_arguments.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

part 'allexp_event.dart';
part 'allexp_state.dart';

class AllexpBloc extends Bloc<AllexpEvent, AllexpState> {
  AllexpBloc() : super(AllexpInitial());

  @override
  Stream<AllexpState> mapEventToState(
    AllexpEvent event,
  ) async* {
    if (event is AllexpRequested) {
      try {
        /// list[0] = date, list[1] = time
        List<String> _convertDateTime(DateTime dateTime) {
          final _localDt = dateTime.toLocal();
          final _newDt = DateFormat.yMMMEd().format(_localDt);
          final _time = DateFormat.jm().format(_localDt);
          return [_newDt.toString(), _time.toString()];
        }

        List<CustomTile> _expenseList = [];
        final _expenses = getCurrentExpenses;
        _expenses.sort(
          (a, b) => DateTime.parse(a.date).compareTo(
            DateTime.parse(b.date),
          ),
        );
        for (var _expense in _expenses.reversed.toList()) {
          if (_expense.groupId == null) {
            final _user = getCurrentFriends
                .firstWhere(
                  (element) => element.id == _expense.to,
                  // In case a bad expense is created, this can handle the null value of the other user
                  orElse: () => Friend(
                      friend:
                          User(firstName: "Error:402 Bad", lastName: "User")),
                )
                .friend;

            final _dateTime = _convertDateTime(DateTime.parse(_expense.date));

            _expenseList.add(
              CustomTile(
                heroTag: "${_expense.id}",
                argObject: ScreenArguments(expense: _expense),
                name: _expense.description,
                balance: _expense.owedShare,
                photoUrl: _expense.pictureUrl ?? "${expenseAvatars[0]}",
                subTitle:
                    "${_dateTime[0]} | ${_dateTime[1]}\n\nWith ${_user.firstName + ' ' + _user.lastName}",
              ),
            );
          } else {
            final _dateTime = _convertDateTime(DateTime.parse(_expense.date));

            final _balance = _expense.expenseUsers
                .firstWhere((element) => element.userId == globalUser.id)
                .netBalance;

            final _groupName = getCurrentGroups
                .firstWhere((element) => element.id == _expense.groupId)
                .name;
            final _user = getCurrentFriends
                .firstWhere((element) => element.id == _expense.to,
                    orElse: () => Friend(friend: globalUser))
                .friend;

            String name;
            if (_user.firstName == globalUser.firstName)
              name = "you";
            else
              name = _user.firstName;

            _expenseList.add(CustomTile(
              heroTag: "${_expense.id}",
              name: _expense.description,
              balance: _balance,
              photoUrl: _expense.pictureUrl ?? "${expenseAvatars[0]}",
              subTitle:
                  "${_dateTime[0]} | ${_dateTime[1]}\n\nBy $name in $_groupName group",
              argObject: ScreenArguments(expense: _expense),
            ));
          }
        }
        yield (AllexpLoaded(expensesList: _expenseList));
      } on PlatformException catch (e) {
        yield (AllexpFailure(message: "Error: ${e.message}"));
      } on TimeoutException catch (e) {
        yield (AllexpFailure(message: "Timeout: ${e.message}"));
      } catch (e) {
        yield (AllexpFailure(message: e.toString()));
      }
    }
  }
}
