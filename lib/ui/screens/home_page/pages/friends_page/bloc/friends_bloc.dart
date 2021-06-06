import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:contri_app/sdk/functions/friends_functions.dart';
import 'package:contri_app/sdk/models/friend_model/friend_model.dart';
import 'package:contri_app/sdk/models/user_model/user_model.dart';
import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/global/storage_constants.dart';
import 'package:contri_app/ui/components/customTile.dart';
import 'package:contri_app/ui/components/scren_arguments.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  FriendsBloc() : super(FriendsInitial());

  @override
  Stream<FriendsState> mapEventToState(
    FriendsEvent event,
  ) async* {
    try {
      if (event is FriendsPageRequested) {
        List<CustomTile> _friendsList = [];
        List<CustomTile> _settledFriendsList = [];

        for (var _friend in getCurrentFriends) {
          double _groupBalance = 0.0;
          double _nonGroupBalance = 0.0;
          // For non-group expenses
          final _nonGroupExpenses =
              getCurrentExpenses.where((element) => element.groupId == null).toList();
          final _friendExpenses =
              _nonGroupExpenses.where((element) => element.to == _friend.friend.id);
          double _balance = 0.0;
          for (var _expense in _friendExpenses) {
            _balance += _expense.owedShare;
          }

          _nonGroupBalance = _balance;

          // For group expenses
          final _groupExps =
              getCurrentExpenses.where((element) => element.groupId != null).toList();
          for (var _exp in _groupExps) {
            if (_exp.to == _friend.id) {
              final _user = _exp.expenseUsers.firstWhere(
                (element) => element.userId == globalUser.id,
                orElse: () => null,
              );
              if (_user != null) {
                _balance += (_user.netBalance);
                _groupBalance += _user.netBalance;
              }
            } else if (_exp.to == globalUser.id) {
              final _user = _exp.expenseUsers.firstWhere(
                (element) => element.userId == _friend.id,
                orElse: () => null,
              );
              if (_user != null) {
                _balance += -(_user.netBalance);
                _groupBalance += -(_user.netBalance);
              }
            }
          }

          if (_balance != 0.0) {
            if (_groupBalance == 0.0) {
              _friendsList.add(
                CustomTile(
                  heroTag: "${_friend.friend.id}",
                  name: "${_friend.friend.firstName + ' ' + _friend.friend.lastName}",
                  balance: _balance, // 0.0 means no expense OR settled up
                  photoUrl: _friend.friend.pictureUrl ?? "NO IMAGE",
                  argObject: ScreenArguments(friend: _friend),
                ),
              );
            } else {
              String getSubtitle({double nonGroupExp, double groupExp}) {
                if (groupExp > 0) {
                  return nonGroupExp > 0
                      ? "\nYou owe $currencySymbol${groupExp.abs().toStringAsFixed(2)} in group expenses\nYou owe $currencySymbol${nonGroupExp.abs().toStringAsFixed(2)} in non-group expenses"
                      : "\nYou owe $currencySymbol${groupExp.abs().toStringAsFixed(2)} in group expenses\nYou are owed $currencySymbol${nonGroupExp.abs().toStringAsFixed(2)} in non-group expenses";
                } else {
                  return nonGroupExp > 0
                      ? "\nYou are owed $currencySymbol${groupExp.abs().toStringAsFixed(2)} in group expenses\nYou owe $currencySymbol${nonGroupExp.abs().toStringAsFixed(2)} in non-group expenses"
                      : "\nYou are owed $currencySymbol${groupExp.abs().toStringAsFixed(2)} in group expenses\nYou are owed $currencySymbol${nonGroupExp.abs().toStringAsFixed(2)} in non-group expenses";
                }
              }

              _friendsList.add(
                CustomTile(
                  heroTag: "${_friend.friend.id}",
                  name: "${_friend.friend.firstName + ' ' + _friend.friend.lastName}",
                  balance: _balance, // 0.0 means no expense OR settled up
                  photoUrl: _friend.friend.pictureUrl ?? "NO IMAGE",
                  argObject: ScreenArguments(friend: _friend),
                  subTitle: getSubtitle(
                    groupExp: _groupBalance,
                    nonGroupExp: _nonGroupBalance,
                  ),
                ),
              );
            }
          } else {
            _settledFriendsList.add(
              CustomTile(
                heroTag: "${_friend.friend.id}",
                name: "${_friend.friend.firstName + ' ' + _friend.friend.lastName}",
                balance: _balance,
                photoUrl: _friend.friend.pictureUrl ?? "NO IMAGE",
                argObject: ScreenArguments(friend: _friend),
              ),
            );
          }
        }

        // Sort the friends list lexicographically
        _friendsList.sort((a, b) => a.name.compareTo(b.name));
        _settledFriendsList.sort((a, b) => a.name.compareTo(b.name));

        yield (FriendsPageLoaded(friendsList: _friendsList, settledFriendsList: _settledFriendsList));
      }
      if (event is AddNewFriend) {
        yield (FriendsPageLoading());
        final _user = User(
          firstName: event.firstName,
          lastName: event.lastName,
          defaultCurrency: event.defaultCurency,
          phoneNumber: event.phoneNumber,
          pictureUrl: userAvatars[Random().nextInt(userAvatars.length)],
        );

        final _friend = Friend(
          friend: _user,
        );

        await FriendFunctions.createFriend(friend: _friend);
        await loadFriends();
        yield (FriendsPageSuccess(firstName: event.firstName, phoneNumber: event.phoneNumber));
      }
    } on PlatformException catch (e) {
      yield (FriendsPageError(message: "Error: ${e.message}"));
    } on TimeoutException catch (e) {
      yield (FriendsPageError(message: "Timeout: ${e.message}"));
    } catch (e) {
      yield (FriendsPageError(message: e.toString()));
    }
  }
}
