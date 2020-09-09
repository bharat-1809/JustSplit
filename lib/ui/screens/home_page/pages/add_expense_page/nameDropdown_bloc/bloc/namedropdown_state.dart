part of 'namedropdown_bloc.dart';

abstract class NamedropdownState extends Equatable {
  const NamedropdownState();

  @override
  List<Object> get props => [];
}

class NameDropdownChanged extends NamedropdownState {
  final String value;
  final List<UserTile> dropdownList;
  NameDropdownChanged({@required this.value, @required this.dropdownList})
      : assert(value != null),
        assert(dropdownList != null);

  @override
  List<Object> get props => [value, dropdownList];
}

class AddingNewFriend extends NamedropdownState {}

class NameDropdownChangeFailure extends NamedropdownState {
  final String message;
  NameDropdownChangeFailure({this.message});

  @override
  List<Object> get props => [message];
}
