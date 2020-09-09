part of 'splitdropdown_bloc.dart';

abstract class SplitdropdownEvent extends Equatable {
  const SplitdropdownEvent();

  @override
  List<Object> get props => [];
}

class SplitDropdownRequested extends SplitdropdownEvent {
  final bool isGroupExpense;
  SplitDropdownRequested({this.isGroupExpense = false});

  @override
  List<Object> get props => [isGroupExpense];
}

class ChangeSplitDropdown extends SplitdropdownEvent {
  final String newValue;
  final List<String> splitList;
  ChangeSplitDropdown({@required this.newValue, @required this.splitList})
      : assert(newValue != null),
        assert(splitList != null);

  @override
  List<Object> get props => [newValue, splitList];
}
