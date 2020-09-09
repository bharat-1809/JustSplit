part of 'splitdropdown_bloc.dart';

abstract class SplitdropdownEvent extends Equatable {
  const SplitdropdownEvent();

  @override
  List<Object> get props => [];
}

class SplitDropdownRequested extends SplitdropdownEvent {
  final bool isGroupExpense;
  final String initialValue;
  SplitDropdownRequested({this.isGroupExpense = false, this.initialValue});

  @override
  List<Object> get props => [isGroupExpense, initialValue];
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
