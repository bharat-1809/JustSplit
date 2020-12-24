part of 'namedropdown_bloc.dart';

abstract class NamedropdownEvent extends Equatable {
  const NamedropdownEvent();

  @override
  List<Object> get props => [];
}

class NameDropdownRequested extends NamedropdownEvent {
  final ScreenArguments initialNameDropdownValue;
  NameDropdownRequested({this.initialNameDropdownValue});

  @override
  List<Object> get props => [initialNameDropdownValue];
}

class ChangeNameDropdown extends NamedropdownEvent {
  final String newValue;
  final List<UserTile> dropdownList;
  ChangeNameDropdown({@required this.newValue, @required this.dropdownList})
      : assert(newValue != null),
        assert(dropdownList != null);

  @override
  List<Object> get props => [newValue, dropdownList];
}

class AddNewFriend extends NamedropdownEvent {}
