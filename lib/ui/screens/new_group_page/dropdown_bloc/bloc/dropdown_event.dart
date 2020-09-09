part of 'dropdown_bloc.dart';

abstract class DropdownEvent extends Equatable {
  const DropdownEvent();
  @override
  List<Object> get props => [];
}

class FriendDropdownRequested extends DropdownEvent {}

class ChangeFriendDropdown extends DropdownEvent {
  final String newValue;
  final List<UserTile> widgetList;
  ChangeFriendDropdown({@required this.newValue, @required this.widgetList})
      : assert(newValue != null),
        assert(widgetList != null);

  @override
  List<Object> get props => [newValue, widgetList];
}
