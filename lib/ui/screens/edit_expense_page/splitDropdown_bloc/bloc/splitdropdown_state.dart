part of 'splitdropdown_bloc.dart';

class SplitdropdownState extends Equatable {
  final String value;
  final List<String> splitList;
  SplitdropdownState({@required this.value, @required this.splitList})
      : assert(value != null),
        assert(splitList != null);

  @override
  List<Object> get props => [value, splitList];
}
