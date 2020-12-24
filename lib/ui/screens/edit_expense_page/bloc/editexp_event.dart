part of 'editexp_bloc.dart';

abstract class EditexpEvent extends Equatable {
  const EditexpEvent();
}

class SaveButtonClicked extends EditexpEvent {
  final String expenseId;
  final String description;
  final double cost;
  final String splitType;
  final String payeeId;
  final bool isGroupExpense;
  final List<String> comments;
  final DateTime dateTime;
  final Expense oldExpense;
  SaveButtonClicked(
      {@required this.expenseId,
      @required this.description,
      @required this.cost,
      @required this.payeeId,
      @required this.isGroupExpense,
      @required this.dateTime,
      @required this.comments,
      @required this.splitType,
      @required this.oldExpense})
      : assert(description != null),
        assert(expenseId != null),
        assert(cost != null),
        assert(oldExpense != null),
        assert(comments != null),
        assert(isGroupExpense != null),
        assert(dateTime != null),
        assert(payeeId != null),
        assert(splitType != null);

  @override
  List<Object> get props => [
        description,
        cost,
        comments,
        dateTime,
        splitType,
        payeeId,
        isGroupExpense,
        expenseId,
        oldExpense
      ];
}

class DeleteExpense extends EditexpEvent {
  final String expenseId;
  DeleteExpense({@required this.expenseId});

  @override
  List<Object> get props => [expenseId];
}
