part of 'dropdown_bloc.dart';

class DropdownState extends Equatable {
  final String value;
  final List<UserTile> widgetList;
  DropdownState({@required this.value, @required this.widgetList})
      : assert(value != null),
        assert(widgetList != null);

  @override
  List<Object> get props => [value, widgetList];
}
