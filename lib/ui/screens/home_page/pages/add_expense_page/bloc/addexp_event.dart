part of 'addexp_bloc.dart';

abstract class AddexpEvent extends Equatable {
  const AddexpEvent();

  @override
  List<Object> get props => [];
}

class AddexpRequested extends AddexpEvent {}

class SaveButtonClicked extends AddexpEvent {
  final String payerId;

  /// Can be a userId or groupId for groupExpense
  final String payeeId;
  final String expenseName;
  final double amount;
  final String splittingType;
  final DateTime dateTime;
  final List<String> comments;
  final bool isGroupExpense;
  final String photoUrl;
  SaveButtonClicked(
      {@required this.photoUrl,
      @required this.payerId,
      @required this.payeeId,
      @required this.expenseName,
      @required this.amount,
      @required this.dateTime,
      @required this.splittingType,
      @required this.isGroupExpense,
      @required this.comments})
      : assert(payeeId != null),
        assert(photoUrl != null),
        assert(payerId != null),
        assert(amount != null),
        assert(comments != null),
        assert(dateTime != null),
        assert(expenseName != null),
        assert(isGroupExpense != null),
        assert(splittingType != null);

  @override
  List<Object> get props => [
        payerId,
        payeeId,
        amount,
        comments,
        dateTime,
        expenseName,
        splittingType,
        isGroupExpense,
        photoUrl,
      ];
}
