import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contri_app/sdk/functions/expenses_functions.dart';
import 'package:contri_app/sdk/models/expense_model/expense_model.dart';
import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/ui/screens/home_page/pages/add_expense_page/splitDropdown_bloc/bloc/splitdropdown_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'addexp_event.dart';
part 'addexp_state.dart';

class AddexpBloc extends Bloc<AddexpEvent, AddexpState> {
  AddexpBloc() : super(AddExpInitial());

  @override
  Stream<AddexpState> mapEventToState(
    AddexpEvent event,
  ) async* {
    try {
      if (event is AddexpRequested) {
        yield (RequestingAddExpMainPage());
      }
      if (event is SaveButtonClicked) {
        yield (AddExpInProgress());
        Expense _expense;
        if (event.isGroupExpense) {
          final _groupMembers = getCurrentGroups
              .firstWhere(
                (element) => element.id == event.payeeId,
                orElse: () => null,
              )
              .members;
          final double netBalance = event.amount / _groupMembers.length;
          List<ExpenseUsers> _expenseUsersList = [];

          for (var _user in _groupMembers) {
            if (_user.id == globalUser.id) {
              _expenseUsersList.add(
                ExpenseUsers(
                  user: globalUser,
                  userId: globalUser.id,
                  netBalance: -(event.amount - netBalance),
                  paidShare: event.amount,
                  owedShare: event.amount - netBalance,
                ),
              );
            } else {
              _expenseUsersList.add(
                ExpenseUsers(
                  user: _user,
                  userId: _user.id,
                  netBalance: netBalance,
                  paidShare: 0.0,
                  owedShare: netBalance,
                ),
              );
            }
          }

          _expense = Expense(
            from: event.payerId,
            pictureUrl: event.photoUrl,
            groupId: event.payeeId,
            comments: event.comments,
            cost: event.amount,
            date: event.dateTime.toIso8601String(),
            description: event.expenseName,
            expenseUsers: _expenseUsersList,
            splitType: event.splittingType,
            createdBy: globalUser.id,
          );
        } else {
          double _owedShare;
          if (event.splittingType == splittingTypes[0]) {
            _owedShare = -(event.amount / 2);
          } else if (event.splittingType == splittingTypes[1]) {
            _owedShare = event.amount;
          } else if (event.splittingType == splittingTypes[2]) {
            _owedShare = -(event.amount);
          } else if (event.splittingType == splittingTypes[3]) {
            _owedShare = (event.amount / 2);
          }

          _expense = Expense(
            pictureUrl: event.photoUrl,
            comments: event.comments,
            from: event.payerId,
            to: event.payeeId,
            createdBy: globalUser.id,
            date: event.dateTime.toIso8601String(),
            description: event.expenseName,
            cost: event.amount,
            owedShare: _owedShare,
            splitType: event.splittingType,
          );
        }
        await ExpensesFunctions.createExpense(_expense);
        await loadExpenses();
        yield (AddExpSuccess());
      }
    } on PlatformException catch (e) {
      yield (AddexpFailure(message: "Error: ${e.message}"));
    } on TimeoutException catch (e) {
      yield (AddexpFailure(message: "Timeout: ${e.message}"));
    } catch (e) {
      yield (AddexpFailure(message: e.toString()));
    }
  }
}
