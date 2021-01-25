import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contri_app/sdk/functions/expenses_functions.dart';
import 'package:contri_app/sdk/models/expense_model/expense_model.dart';
import 'package:contri_app/global/global_helpers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

part 'editexp_event.dart';
part 'editexp_state.dart';

List<String> splittingTypes = [
  "Paid by you and split equally",
  "You owe the full amount",
  "They owe the full amount",
  "Paid by the other person and split Equally",
];

class EditexpBloc extends Bloc<EditexpEvent, EditexpState> {
  EditexpBloc() : super(EditexpInitial());

  @override
  Stream<EditexpState> mapEventToState(
    EditexpEvent event,
  ) async* {
    try {
      if (event is SaveButtonClicked) {
        yield (EditExpLoading());

        String _splitType;

        if (event.splitType.startsWith('_')) {
          _splitType = event.splitType.substring(1);
        } else {
          _splitType = event.splitType;
        }

        if (event.oldExpense.comments.toString() == event.comments.toString() &&
            event.oldExpense.cost.abs() == event.cost.abs() &&
            event.oldExpense.date == event.dateTime.toIso8601String() &&
            event.oldExpense.description == event.description &&
            event.oldExpense.splitType == _splitType) {
          /// No Change in expense so no updation
          yield (EditExpSuccess());
        } else {
          Expense _expense;

          if (event.isGroupExpense) {
            final _groupMembers = getCurrentGroups
                .firstWhere(
                  (element) => element.id == event.payeeId,
                  orElse: () => null,
                )
                .members;
            final double netBalance = event.cost / _groupMembers.length;

            List<ExpenseUsers> _expenseUsersList = [];

            for (var _user in _groupMembers) {
              if (_user.id == globalUser.id) {
                _expenseUsersList.add(
                  ExpenseUsers(
                    user: globalUser,
                    userId: globalUser.id,
                    netBalance: -(event.cost - netBalance),
                    paidShare: event.cost,
                    owedShare: event.cost - netBalance,
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
              from: globalUser.id,
              groupId: event.payeeId,
              comments: event.comments,
              cost: event.cost,
              date: event.dateTime.toIso8601String(),
              description: event.description,
              expenseUsers: _expenseUsersList,
              splitType: _splitType,
              updatedBy: globalUser.id,
            );
          } else {
            double _owedShare;
            if (_splitType == splittingTypes[0]) {
              _owedShare = -(event.cost / 2);
            } else if (_splitType == splittingTypes[1]) {
              _owedShare = event.cost;
            } else if (_splitType == splittingTypes[2]) {
              _owedShare = -(event.cost);
            } else if (_splitType == splittingTypes[3]) {
              _owedShare = (event.cost / 2);
            }
            _expense = Expense(
              comments: event.comments,
              from: globalUser.id,
              to: event.payeeId,
              date: event.dateTime.toIso8601String(),
              description: event.description,
              cost: event.cost,
              owedShare: _owedShare,
              splitType: _splitType,
              updatedBy: globalUser.id,
            );
          }

          await ExpensesFunctions.updateExpense(id: event.expenseId, expense: _expense);
          await loadExpenses();
          yield (EditExpSuccess());
        }
      } else if (event is DeleteExpense) {
        yield (EditExpLoading());
        await ExpensesFunctions.deleteExpense(id: event.expenseId);
        await loadExpenses();
        yield (EditExpSuccess());
      }
    } on PlatformException catch (e) {
      yield (EditExpFailed(message: "Error: ${e.message}"));
    } on TimeoutException catch (e) {
      yield (EditExpFailed(message: "Timeout: ${e.message}"));
    } catch (e) {
      yield (EditExpFailed(message: e.toString()));
    }
  }
}
